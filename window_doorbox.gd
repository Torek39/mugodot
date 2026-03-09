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
		_move_boxes()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Коробки не сдвинулись"

func _check_code(text: String) -> bool:
	var has_return: bool = false
	var has_def: bool = false
	var has_assignment: bool = false
	
	for line in text.split("\n"):
		var s := line.strip_edges().to_lower()
		
		if s.begins_with("return "):
			has_return = true
		
		if s.begins_with("def "):
			has_def = true
		
		if "total =" in s or "total=" in s:
			has_assignment = true
	
	if not has_def:
		code_edit.text += "\n# Проверь объявление функции"
		return false
	if not has_assignment:
		code_edit.text += "\n# Не хватает вычисления total"
		return false
	if not has_return:
		code_edit.text += "\n# Функция должна вернуть значение через return"
		return false
	
	return true

# ==========================
# ДВИЖЕНИЕ КОРОБОК И ОТКРЫТИЕ ДВЕРИ
# ==========================
func _move_boxes() -> void:
	Global.doorbox_opened = true
	
	var box1 = _find_node_by_name(get_tree().current_scene, "box1")
	var box2 = _find_node_by_name(get_tree().current_scene, "box2")
	var box3 = _find_node_by_name(get_tree().current_scene, "box3")
	
	if box1:
		var tween1 = create_tween()
		tween1.tween_property(box1, "position:y", -63.0, 0.8)
		await get_tree().create_timer(0.3).timeout
	
	if box2:
		var tween2 = create_tween()
		tween2.tween_property(box2, "position:y", -63.0, 0.8)
		await get_tree().create_timer(0.3).timeout
	
	if box3:
		var tween3 = create_tween()
		tween3.tween_property(box3, "position:y", -63.0, 0.8)
		await get_tree().create_timer(0.8).timeout
	
	_open_door()

func _open_door() -> void:
	var door = _find_node_by_name(get_tree().current_scene, "door_box")
	print("Door found: ", door)  # ДЕБАГ
	if door and door.has_method("open"):
		print("Opening door")  # ДЕБАГ
		door.open()
	else:
		print("Door not found or no method")  # ДЕБАГ

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
