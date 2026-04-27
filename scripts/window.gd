extends Node2D
# ==========================
# ЭКСПОРТ
# ==========================
@export var door_node_path: NodePath = NodePath("../door")
# ==========================
# УЗЛЫ
# ==========================
@onready var popup := $Window
@onready var code_edit := popup.get_node_or_null("Camera2D/TextEdit")
# ==========================
# КОНСТАНТЫ
# ==========================
const LOCKED_SIZE := Vector2(640, 360)
# ==========================
# КНОПКИ
# ==========================
var run_button: Button
var reset_button: Button
# ==========================
# ПЕРЕМЕННЫЕ
# ==========================
var initial_code: String = ""
# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	_setup_popup()
	_find_buttons()
	_connect_signals()
	if code_edit:
		initial_code = code_edit.text
	popup.hide()

func _setup_popup() -> void:
	if popup is Control:
		popup.size = LOCKED_SIZE
		popup.min_size = LOCKED_SIZE

func _connect_signals() -> void:
	if run_button:
		run_button.pressed.connect(_on_run_pressed)
	if reset_button:
		reset_button.pressed.connect(_on_reset_pressed)
	if popup.has_signal("close_requested"):
		popup.close_requested.connect(_on_close_pressed)

# ==========================
# ОТКРЫТИЕ / ЗАКРЫТИЕ / СБРОС
# ==========================
func open_window() -> void:
	Global.input_blocked = true
	popup.show()
	if code_edit:
		code_edit.text = initial_code
		code_edit.grab_focus()
		AudioManager.play_sfx("window_open")


func _on_reset_pressed() -> void:
	if code_edit:
		code_edit.text = initial_code
		code_edit.grab_focus()

func _on_close_pressed() -> void:
	popup.hide()
	Global.input_blocked = false

# ==========================
# ПРОВЕРКА КОДА
# ==========================
func _on_run_pressed() -> void:
	if not code_edit:
		return
	if _check_code(code_edit.text):
		_unlock_door()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Дверь не реагирует"

func _check_code(text: String) -> bool:
	for line in text.split("\n"):
		var cleaned := line.strip_edges().to_lower()
		if cleaned.begins_with("door_open") and "=" in cleaned:
			var value := cleaned.split("=")[1].strip_edges()
			if value == "true":
				AudioManager.play_sfx("success")
				return true
	AudioManager.play_sfx("error")
	return false

# ==========================
# ОТКРЫТИЕ ДВЕРИ
# ==========================
func _unlock_door() -> void:
	Global.door_open = true
	var door = get_tree().current_scene.get_node_or_null(door_node_path)
	if door and door.has_method("open"):
		door.open()

# ==========================
# ПОИСК КНОПОК
# ==========================
func _find_buttons() -> void:
	var buttons: Array[Button] = []
	_collect_buttons(popup, buttons)
	for b in buttons:
		var name_lower := b.name.to_lower()
		if "run" in name_lower:
			run_button = b
		elif "reset" in name_lower or "close" in name_lower:
			reset_button = b
	# Фоллбэк
	if not run_button and buttons.size() > 0:
		run_button = buttons[0]
	if not reset_button and buttons.size() > 1:
		reset_button = buttons[1]

func _collect_buttons(node: Node, out: Array[Button]) -> void:
	for child in node.get_children():
		if child is Button:
			out.append(child)
		_collect_buttons(child, out)
