extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_moving: bool = false

func interact(_player = null) -> void:
	print("Голем: взаимодействие") # по необходимости можно вызывать окно напрямую, но у тебя камень открывает окно

# offset: Vector2 в пикселях; duration в секундах
func move_by(offset: Vector2, duration: float = 0.25) -> void:
	if is_moving:
		return
	is_moving = true
	var target = position + offset

	# если есть анимация ходьбы — воспроизвести
	if animated_sprite and animated_sprite.has_animation("walk"):
		animated_sprite.play("walk")

	var tw = create_tween()
	tw.tween_property(self, "position", target, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_callback(Callable(self, "_on_move_complete"))

func _on_move_complete() -> void:
	is_moving = false
	if animated_sprite and animated_sprite.has_animation("idle"):
		animated_sprite.play("idle")
