extends Node2D

@export var golem_node_path: NodePath = NodePath("Golem")

@onready var popup: Node = $Window_golem
@onready var code_edit: TextEdit = popup.get_node_or_null("Camera2D/TextEdit") if popup else null

const LOCKED_SIZE := Vector2(640, 360)

var run_button: Button = null
var close_button: Button = null


func _ready() -> void:
	if popup == null:
		printerr("window_golem.gd: узел Window_golem не найден")
		return

	if popup is Control:
		popup.size = LOCKED_SIZE
		popup.min_size = LOCKED_SIZE

	_find_buttons()

	if run_button:
		run_button.pressed.connect(Callable(self, "_on_run_pressed"))

	if close_button:
		close_button.pressed.connect(Callable(self, "_on_close_pressed"))

	if popup.has_signal("close_requested"):
		var c := Callable(self, "_on_window_close_requested")
		if not popup.is_connected("close_requested", c):
			popup.connect("close_requested", c)

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

	var dx := _parse_move_value(code_edit.text)

	if dx != INF:
		_move_golem(dx)
		_close()
	else:
		code_edit.append_text("\n# Неверный код. Используй: golem_move = -30")


func _parse_move_value(text: String) -> int:
	for line in text.split("\n"):
		var s := line.strip_edges()
		if s == "":
			continue

		var sl := s.to_lower()

		if sl.begins_with("golem_move") and "=" in sl:
			var rhs := sl.split("=")[1].strip_edges()

			if rhs.is_valid_int():
				return int(rhs)

			if rhs == "true":
				return -30

	return INF


func _move_golem(dx: int) -> void:
	var level := get_tree().get_current_scene()
	if not level:
		printerr("window_golem.gd: текущая сцена не найдена")
		return

	var golem: Node = null

	if golem_node_path != NodePath(""):
		golem = level.get_node_or_null(golem_node_path)

	if golem == null:
		golem = level.find_node("Golem", true, false)

	if golem == null:
		golem = level.find_node("golem", true, false)

	if golem and golem.has_method("move_by"):
		golem.call("move_by", Vector2(dx, 0))
	else:
		printerr("window_golem.gd: голем не найден или нет метода move_by()")


func _find_buttons() -> void:
	var buttons: Array[Button] = []
	_collect_buttons(popup, buttons)

	if buttons.is_empty():
		printerr("window_golem.gd: кнопки не найдены")
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
