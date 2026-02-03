extends Node2D

@export var door_node_path: NodePath = NodePath("door")

@onready var popup := $Window
@onready var code_edit := popup.get_node_or_null("Camera2D/TextEdit")

const LOCKED_SIZE := Vector2(640, 360)

var run_button: Button = null
var close_button: Button = null

func _ready() -> void:
	if popup == null:
		printerr("window.gd: узел Window не найден")
		return

	if popup is Control:
		popup.size = LOCKED_SIZE
		popup.min_size = LOCKED_SIZE

	_find_buttons()

	if run_button:
		run_button.pressed.connect(_on_run_pressed)

	if close_button:
		close_button.pressed.connect(_on_close_pressed)

	# Корректное подключение сигнала в Godot 4
	if popup.has_signal("close_requested"):
		var call = Callable(self, "_on_window_close_requested")
		if not popup.is_connected("close_requested", call):
			popup.connect("close_requested", call)

	popup.hide()

func open_window() -> void:
	Global.input_blocked = true
	popup.show()
	if code_edit:
		code_edit.grab_focus()

func _on_close_pressed() -> void:
	_close()

func _on_window_close_requested() -> void:
	_close()

func _close() -> void:
	popup.hide()
	Global.input_blocked = false

func _on_run_pressed() -> void:
	if not code_edit:
		return

	if _check_code(code_edit.text):
		_unlock_door()
		_close()
	else:
		code_edit.text += "\n# Дверь не реагирует"

func _check_code(text: String) -> bool:
	for line in text.split("\n"):
		var s := line.strip_edges().to_lower()
		if s.begins_with("door_open") and "=" in s:
			var rhs := s.split("=")[1].strip_edges()
			if rhs == "true":
				return true
	return false

func _unlock_door() -> void:
	Global.door_open = true  # Выставляем флаг двери
	var level = get_tree().get_current_scene()
	if not level:
		return
	var door = level.get_node_or_null(door_node_path)
	if door and door.has_method("open"):
		door.open()  # Разблокируем дверь

func _find_buttons() -> void:
	var buttons: Array[Button] = []
	_collect_buttons(popup, buttons)

	if buttons.is_empty():
		printerr("window.gd: кнопки не найдены")
		return

	for b in buttons:
		if b.name.to_lower().contains("run"):
			run_button = b
		elif b.name.to_lower().contains("close"):
			close_button = b

	if run_button == null:
		run_button = buttons[0]

	if close_button == null and buttons.size() > 1:
		close_button = buttons[1]

func _collect_buttons(node: Node, out: Array) -> void:
	for child in node.get_children():
		if child is Button:
			out.append(child)
		_collect_buttons(child, out)
