extends StaticBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_pulled: bool = false

func pull() -> void:
	if not is_pulled:
		is_pulled = true
		if animated_sprite:
			for frame in range(5):
				animated_sprite.frame = frame
				await get_tree().create_timer(0.1).timeout
