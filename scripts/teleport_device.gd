extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $StatusLabel
@onready var interaction_area: Area2D = $InteractionArea

var is_activated: bool = false
var player_in_range: bool = false
var target_position: Vector2 = Vector2(-1622.0, -101.0)

func _ready() -> void:
	if sprite:
		sprite.play("idle")
	
	if label:
		label.visible = false
		label.modulate.a = 0.0
	
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	
	if Global.teleport_activated:
		is_activated = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		if label:
			label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range and not Global.input_blocked:
		if is_activated:
			_teleport_player()
		else:
			_show_status()

func _teleport_player() -> void:
	var player = _find_player_recursive(get_tree().current_scene)
	if player:
		player.global_position = target_position
	else:
		push_error("Player not found!")

func _find_player_recursive(node: Node) -> Node:
	if node.name == "player" and node is CharacterBody2D:
		return node
	for child in node.get_children():
		var found = _find_player_recursive(child)
		if found:
			return found
	return null

func _show_status() -> void:
	if not label:
		return
	label.visible = true
	label.modulate.a = 0.0
	label.text = "Нет координат..."
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): label.visible = false)

func activate() -> void:
	if is_activated:
		return
	is_activated = true
	Global.teleport_activated = true
	if label:
		label.text = "Координаты установлены!"
		_show_activation_text()

func _show_activation_text() -> void:
	if not label:
		return
	label.visible = true
	label.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func(): label.visible = false)
