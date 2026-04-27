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

# Целевые значения из data = "12,25,8"
const TARGET_X := 12
const TARGET_Y := 25
const TARGET_Z := 8

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
	var result := _check_code(code_edit.text)
	if result == "":
		_activate_teleport()
		_on_close_pressed()

func _add_error(msg: String) -> void:
	if code_edit:
		code_edit.text += "\n# " + msg

func _check_code(text: String) -> String:
	var lower := text.to_lower()
	var no_spaces := text.replace(" ", "").to_lower()

	# --- Защита шаблона ---
	if not "data" in lower:
		_add_error("Не удаляй переменную data")
		return "error"
	if not "coords" in lower:
		_add_error("Не удаляй переменную coords")
		return "error"
	if not "split" in lower:
		_add_error("Используй split для разделения строки")
		return "error"
	if not "teleport()" in no_spaces:
		_add_error("Не удаляй вызов teleport()")
		return "error"

	# --- Проверка индексов ---
	if not "[0]" in text:
		_add_error("Укажи индекс [0] для X")
		return "error"
	if not "[1]" in text:
		_add_error("Укажи индекс [1] для Y")
		return "error"
	if not "[2]" in text:
		_add_error("Укажи индекс [2] для Z")
		return "error"

	# --- Проверка int() ---
	if not "int(" in lower:
		_add_error("Преобразуй строки в числа через int()")
		return "error"

	# --- Проверка наличия if ---
	if not "if " in lower:
		_add_error("Добавь проверку условий через if")
		return "error"

	# --- Проверка диапазонов через regex ---
	var range_rx := RegEx.new()
	range_rx.compile(">= *(\\d+).*?<= *(\\d+)")
	var matches := range_rx.search_all(text)

	if matches.size() < 3:
		_add_error("Нужны три диапазона (>= ... <=) для x, y, z")
		return "error"

	var ranges: Array = []
	for m in matches:
		var lo := int(m.get_string(1))
		var hi := int(m.get_string(2))
		ranges.append([lo, hi])

	# --- Валидность каждого диапазона (lo < hi) ---
	var labels := ["X", "Y", "Z"]
	for i in 3:
		var r = ranges[i]
		if r[0] >= r[1]:
			_add_error("Диапазон для %s невалиден: нижняя граница >= верхней" % labels[i])
			return "error"

	# --- Целевые значения должны попадать в диапазоны ---
	var targets := [TARGET_X, TARGET_Y, TARGET_Z]
	for i in 3:
		var r = ranges[i]
		if targets[i] < r[0] or targets[i] > r[1]:
			_add_error("Диапазон для %s не включает правильное значение" % labels[i])
			return "error"

	return ""

# ==========================
# АКТИВАЦИЯ ТЕЛЕПОРТА
# ==========================
func _activate_teleport() -> void:
	Global.teleport_activated = true
	var device = _find_node_by_name(get_tree().current_scene, "teleport_device")
	if device and device.has_method("activate"):
		device.activate()

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
