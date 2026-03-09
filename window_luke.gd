extends Node2D
# ==========================
# ЭКСПОРТ
# ==========================
@export var luke_path: NodePath = NodePath("../Luke")
# ==========================
# УЗЛЫ
# ==========================
@onready var popup := $Window
@onready var code_edit := popup.get_node_or_null("Camera2D/TextEdit")
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
		_unlock_luke()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Люк не реагирует"

func _check_code(text: String) -> bool:
	var has_if_with_condition: bool = false
	var has_function_call: bool = false
	var regex_if := RegEx.new()
	regex_if.compile("if\\s+[a-zA-Z_][a-zA-Z0-9_]*")
	var regex_function := RegEx.new()
	regex_function.compile("[a-zA-Z_][a-zA-Z0-9_]*\\(\\)")
	for line in text.split("\n"):
		if regex_if.search(line):
			has_if_with_condition = true
		if regex_function.search(line):
			has_function_call = true
	return has_if_with_condition and has_function_call

# ==========================
# ОТКРЫТИЕ ЛЮКА
# ==========================
func _unlock_luke() -> void:
	Global.luke_open = true
	var luke = get_tree().current_scene.get_node_or_null(luke_path)
	if luke and luke.has_method("unlock"):
		luke.unlock()

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
	if not run_button and buttons.size() > 0:
		run_button = buttons[0]
	if not reset_button and buttons.size() > 1:
		reset_button = buttons[1]

func _collect_buttons(node: Node, out: Array[Button]) -> void:
	for child in node.get_children():
		if child is Button:
			out.append(child)
		_collect_buttons(child, out)
