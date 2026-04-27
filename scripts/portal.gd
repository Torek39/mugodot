extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_open: bool = false

func _ready() -> void:
	visible = false
	body_entered.connect(_on_body_entered)

func activate() -> void:
	if is_open:
		return
	
	visible = true
	is_open = true
	
	if animated_sprite:
		animated_sprite.play("opening")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if is_open and body.name == "player":
		get_tree().change_scene_to_file("res://level/level_3.tscn")
