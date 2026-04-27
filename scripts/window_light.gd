extends Node2D
# ==========================
# ЭКСПОРТ
# ==========================
@export var barrier_path: NodePath = NodePath("../LightBarrier")
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
		_unlock_barrier()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Свет не включается"

func _check_code(text: String) -> bool:
	var plus_equal_count: int = 0
	var has_if: bool = false
	var has_function_call: bool = false
	var regex_function := RegEx.new()
	regex_function.compile("[a-zA-Z_][a-zA-Z0-9_]*\\(\\)")
	for line in text.split("\n"):
		var s := line.strip_edges().to_lower()
		if "+=" in s:
			plus_equal_count += 1
		if s.begins_with("if "):
			has_if = true
		if regex_function.search(line):
			has_function_call = true
	return plus_equal_count >= 3 and has_if and has_function_call

# ==========================
# УБРАТЬ БАРЬЕР И ТЬМУ
# ==========================
func _unlock_barrier() -> void:
	Global.light_on = true
	var barrier = _find_node_by_name(get_tree().current_scene, "light_barrier")
	print("Barrier found: ", barrier)
	if barrier and barrier.has_method("remove_barrier"):
		print("Removing barrier")
		barrier.remove_barrier()
	else:
		print("Barrier not found or no method")
	var darkness = get_tree().current_scene.get_node_or_null("Darkness")
	print("Darkness found: ", darkness)
	if darkness and darkness.has_method("remove_darkness"):
		print("Removing darkness")
		darkness.remove_darkness()
	else:
		print("Darkness not found or no method")

# ==========================
# ПОМОЩНИКИ
# ==========================
func _find_node_by_name(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var result = _find_node_by_name(child, node_name)
		if result:
			return result
	return null

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
