extends Node2D
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
		_activate_levers()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Рычаги не активированы"

func _check_code(text: String) -> bool:
	var has_for: bool = false
	var has_range: bool = false
	var has_function_call: bool = false
	var regex_function := RegEx.new()
	regex_function.compile("[a-zA-Z_][a-zA-Z0-9_]*\\(\\)")
	for line in text.split("\n"):
		var s := line.strip_edges().to_lower()
		if s.begins_with("for "):
			has_for = true
		if "range" in s:
			has_range = true
		if regex_function.search(line):
			has_function_call = true
	return has_for and has_range and has_function_call

# ==========================
# АКТИВАЦИЯ РЫЧАГОВ И ДВИЖЕНИЕ СТАТУЙ
# ==========================
func _activate_levers() -> void:
	Global.levers_activated = true
	var lever1 = _find_node_by_name(get_tree().current_scene, "lever1")
	var lever2 = _find_node_by_name(get_tree().current_scene, "lever2")
	var lever3 = _find_node_by_name(get_tree().current_scene, "lever3")
	if lever1 and lever1.has_method("pull"):
		lever1.pull()
		await get_tree().create_timer(0.5).timeout
	if lever2 and lever2.has_method("pull"):
		lever2.pull()
		await get_tree().create_timer(0.5).timeout
	if lever3 and lever3.has_method("pull"):
		lever3.pull()
		await get_tree().create_timer(0.5).timeout
	_move_statues()

func _move_statues() -> void:
	var statue1 = _find_node_by_name(get_tree().current_scene, "statue")
	var statue2 = _find_node_by_name(get_tree().current_scene, "statue2")
	if statue1:
		var tween1 = create_tween()
		tween1.tween_property(statue1, "position:x", statue1.position.x - 20.0, 0.8)
	if statue2:
		var tween2 = create_tween()
		tween2.tween_property(statue2, "position:x", statue2.position.x + 20.0, 0.8)

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
