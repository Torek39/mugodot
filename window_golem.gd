extends Node2D
# ==========================
# ЭКСПОРТ
# ==========================
@export var golem_path: NodePath = NodePath("Golem")
# ==========================
# УЗЛЫ
# ==========================
@onready var popup: Node = $Window_golem
@onready var code_edit: TextEdit = popup.get_node_or_null("Camera2D/TextEdit") if popup else null
@onready var run_button: Button = popup.get_node_or_null("Run") if popup else null
@onready var reset_button: Button = popup.get_node_or_null("Reset") if popup else null  # ← было Close
# ==========================
# ПЕРЕМЕННЫЕ
# ==========================
var initial_code: String = ""
# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	if code_edit:
		initial_code = code_edit.text
	_connect_signals()
	popup.hide()

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
		_unlock_golem()
		_on_close_pressed()
	else:
		code_edit.text += "\n# Что-то не так..."

func _check_code(text: String) -> bool:
	var current_power: int = -1
	var required_power: int = -1
	var has_greater_sign: bool = false
	for line in text.split("\n"):
		var s := line.strip_edges().replace(" ", "").to_lower()
		if s.begins_with("current_power="):
			var value_str := s.split("=")[1].split("//")[0].strip_edges()
			if value_str.is_valid_int():
				current_power = int(value_str)
		if s.begins_with("required_power="):
			var value_str := s.split("=")[1].strip_edges()
			if value_str.is_valid_int():
				required_power = int(value_str)
		if "current_power>required_power" in s or "current_power>=required_power" in s:
			has_greater_sign = true
	return current_power != -1 and required_power != -1 and has_greater_sign and current_power > required_power

# ==========================
# ДВИЖЕНИЕ ГОЛЕМА
# ==========================
func _unlock_golem() -> void:
	var golem = get_parent().get_parent().get_node_or_null("Golem")
	if not golem:
		return
	var target_x = golem.position.x - 30
	var duration = 1.5
	var start_x = golem.position.x
	var tween = create_tween()
	tween.tween_method(
		func(t: float):
			golem.global_position.x = lerp(start_x, target_x, t),
		0.0, 1.0, duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): golem.get_node("CollisionShape2D").disabled = true)
