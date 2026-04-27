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
		_fix_corridor()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Сектор не очищен"

func _check_code(text: String) -> bool:
	var lower = text.to_lower()
	var no_spaces = text.replace(" ", "").to_lower()
	
	# Защита шаблона
	if not "raw_dump" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "data" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "pos" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "status" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "while" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "if" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "erase_tiles_at" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	
	# Проверка правильности
	var has_split: bool = false
	var has_len: bool = false
	var has_int: bool = false
	var has_break: bool = false
	var has_increment: bool = false
	
	for line in text.split("\n"):
		var s = line.strip_edges().to_lower().replace(" ", "")
		
		if "raw_dump.split(" in s:
			has_split = true
		if "len(data)" in s:
			has_len = true
		if "int(data[pos])" in s:
			has_int = true
		if s == "break" or s.begins_with("break"):
			has_break = true
		if "pos+=1" in s or "pos=pos+1" in s:
			has_increment = true
	
	if not has_split:
		code_edit.text += "\n# Раздели строку через split"
		return false
	if not has_len:
		code_edit.text += "\n# Используй len для длины массива"
		return false
	if not has_int:
		code_edit.text += "\n# Преобразуй элемент в число через int()"
		return false
	if not has_break:
		code_edit.text += "\n# Прерви цикл при нахождении сбоя"
		return false
	if not has_increment:
		code_edit.text += "\n# Сдвинь указатель pos вперёд"
		return false
	
	return true

# ==========================
# ОЧИСТКА КОРИДОРА
# ==========================
func _fix_corridor() -> void:
	Global.glitch_fixed = true
	
	var corridor = _find_node_by_name(get_tree().current_scene, "glitch_corridor")
	if corridor and corridor.has_method("activate"):
		corridor.activate()

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
