extends StaticBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if Global.luke_open and not is_unlocked:
		unlock()

func unlock() -> void:
	is_unlocked = true
	if collision_shape:
		collision_shape.disabled = true
	
	if animated_sprite:
		for frame in range(4):
			animated_sprite.frame = frame
			await get_tree().create_timer(0.1).timeout
	
	teleport_to_level2()

func teleport_to_level2() -> void:
	get_tree().change_scene_to_file("res://level_2.tscn")
