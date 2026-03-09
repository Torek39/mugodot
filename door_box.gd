extends StaticBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_open: bool = false

func open() -> void:
	if is_open:
		return
	
	is_open = true
	animated_sprite.frame = 1
	collision_shape.disabled = true
