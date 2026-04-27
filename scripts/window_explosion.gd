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
		_detonate_wall()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Взрыв не удался"

func _check_code(text: String) -> bool:
	var lower = text.to_lower()
	var no_spaces = text.replace(" ", "").to_lower()
	
	# Защита шаблона
	if not "power_ready" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "detonator_active" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "blast" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "blow_wall()" in no_spaces:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "система не готова" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	
	# Проверка правильности
	var has_true: bool = false
	var has_and: bool = false
	var has_plus_equal: bool = false
	var has_if_blast: bool = false
	
	for line in text.split("\n"):
		var s = line.strip_edges().to_lower().replace(" ", "")
		
		if "detonator_active=true" in s:
			has_true = true
		if "and" in s:
			has_and = true
		if "blast+=100" in s or "blast=100" in s or s.contains("blast+="):
			has_plus_equal = true
		if s.begins_with("ifblast>=") or s.begins_with("ifblast>="):
			has_if_blast = true
	
	if not has_true:
		code_edit.text += "\n# Детонатор должен быть активен"
		return false
	if not has_and:
		code_edit.text += "\n# Используй and для проверки обоих условий"
		return false
	if not has_plus_equal:
		code_edit.text += "\n# Увеличь мощность взрыва"
		return false
	if not has_if_blast:
		code_edit.text += "\n# Проверь достаточно ли мощности"
		return false
	
	return true

# ==========================
# ДЕТОНАЦИЯ
# ==========================
func _detonate_wall() -> void:
	Global.wall_detonated = true
	
	var wall = _find_node_by_name(get_tree().current_scene, "explosion_wall")
	if wall and wall.has_method("detonate"):
		wall.detonate()

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
