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
		_dispel_poison()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Яд не рассеялся"

func _check_code(text: String) -> bool:
	var lower = text.to_lower()
	var no_spaces = text.replace(" ", "").to_lower()
	
	# Защита шаблона — проверка переменных и структуры
	if not "materials" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "\"herbs\"" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "\"crystals\"" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "\"essence\"" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "antidote_power" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "if" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "dispel_poison()" in no_spaces:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	if not "else" in lower:
		code_edit.text += "\n# Не меняй начальный код"
		return false
	
	# Проверка правильности решения — сумма трёх ключей
	var has_correct_sum: bool = false
	
	for line in text.split("\n"):
		var s = line.strip_edges().to_lower().replace(" ", "")
		
		# Проверяем что antidote_power присваивается сумма из словаря
		if s.begins_with("antidote_power="):
			# Должно быть materials["herbs"]+materials["crystals"]+materials["essence"]
			if "materials[" in s and "\"herbs\"" in s and "\"crystals\"" in s and "\"essence\"" in s:
				has_correct_sum = true
	
	if not has_correct_sum:
		code_edit.text += "\n# Сложи все три ингредиента из словаря"
		return false
	
	return true

# ==========================
# РАССЕЯНИЕ ЯДА
# ==========================
func _dispel_poison() -> void:
	Global.poison_dispelled = true
	
	var cloud = _find_node_by_name(get_tree().current_scene, "poison_cloud")
	if cloud:
		# Ищем спрайты внутри
		var sprite_a = cloud.get_node_or_null("SpriteA")
		var sprite_b = cloud.get_node_or_null("SpriteB")
		
		var tween = create_tween()
		
		if sprite_a:
			tween.parallel().tween_property(sprite_a, "modulate:a", 0.0, 1.0)
		if sprite_b:
			tween.parallel().tween_property(sprite_b, "modulate:a", 0.0, 1.0)
		
		await tween.finished
		cloud.queue_free()

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
