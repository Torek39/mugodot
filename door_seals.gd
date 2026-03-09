extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_open: bool = false

func interact(_player = null) -> void:
	if Global.seals_open and not is_open:
		open()

func open() -> void:
	animated_sprite.frame = 1
	collision_shape.disabled = true
	is_open = true
