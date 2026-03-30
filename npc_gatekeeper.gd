extends StaticBody2D
# ==========================
# УЗЛЫ
# ==========================
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var dialog_labels: Array[Label] = [
	$DialogBefore1,
	$DialogBefore2,
	$DialogBefore3,
	$DialogBefore4,
	$DialogBefore5
]
@onready var dialog_after: Label = $DialogAfter
# ==========================
# ПЕРЕМЕННЫЕ
# ==========================
var is_solved: bool = false
var after_shown: bool = false
var rng = RandomNumberGenerator.new()
# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	if sprite:
		sprite.play("idle")
	
	for label in dialog_labels:
		if label:
			label.visible = false
			label.modulate.a = 0.0
	
	if dialog_after:
		dialog_after.visible = false
		dialog_after.modulate.a = 0.0
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)

# ==========================
# ДИАЛОГ
# ==========================
func interact(_player = null) -> void:
	if is_solved:
		_show_after()
	else:
		_show_random_before()

func _show_random_before() -> void:
	var available: Array[Label] = []
	for label in dialog_labels:
		if label:
			available.append(label)
	
	if available.is_empty():
		return
	
	var idx = rng.randi_range(0, available.size() - 1)
	var label = available[idx]
	
	_hide_all_dialogs()
	label.visible = true
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): label.visible = false)

func _show_after() -> void:
	if not dialog_after:
		return
	
	_hide_all_dialogs()
	dialog_after.visible = true
	
	if not after_shown:
		after_shown = true
	
	var tween = create_tween()
	tween.tween_property(dialog_after, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.0)
	tween.tween_property(dialog_after, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): dialog_after.visible = false)

func _hide_all_dialogs() -> void:
	for label in dialog_labels:
		if label:
			label.visible = false
			label.modulate.a = 0.0
	if dialog_after:
		dialog_after.visible = false
		dialog_after.modulate.a = 0.0

# ==========================
# СОСТОЯНИЕ
# ==========================
func set_solved() -> void:
	is_solved = true
	_show_after()

func _on_body_entered(_body: Node2D) -> void:
	pass

func _on_body_exited(_body: Node2D) -> void:
	_hide_all_dialogs()
