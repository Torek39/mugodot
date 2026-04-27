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
		_open_chest_sequence()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Замок не поддаётся"

func _check_code(text: String) -> bool:
	var lower = text.to_lower()
	var no_spaces = text.replace(" ", "").to_lower()
	
	# Защита шаблона
	if not "inventory" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "ржавый ключ" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "камень" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "цветок" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "len" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	
	# Проверка правильности
	var has_if: bool = false
	var has_index_zero: bool = false
	var has_len_inventory: bool = false
	
	for line in text.split("\n"):
		var s = line.strip_edges().to_lower().replace(" ", "")
		
		if s.begins_with("if"):
			has_if = true
		if "inventory[0]" in s:
			has_index_zero = true
		if "len(inventory)" in s:
			has_len_inventory = true
	
	if not has_if:
		code_edit.text += "\n# Начни с проверки условия"
		return false
	if not has_index_zero:
		code_edit.text += "\n# Проверь первый элемент инвентаря"
		return false
	if not has_len_inventory:
		code_edit.text += "\n# Проверь количество предметов"
		return false
	
	return true

# ==========================
# ОТКРЫТИЕ СУНДУКА И АТАКА
# ==========================
func _open_chest_sequence() -> void:
	Global.guardian_chest_opened = true
	
	# Открываем сундук
	var chest = _find_node_by_name(get_tree().current_scene, "treasure_chest")
	if chest and chest.has_method("open"):
		chest.open()
	
	# Активируем голема (атака + диалог)
	var golem = _find_node_by_name(get_tree().current_scene, "golem_guardian")
	if golem and golem.has_method("on_chest_opened"):
		golem.on_chest_opened()

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
