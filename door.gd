# door.gd
extends StaticBody2D
class_name Door

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_open: bool = false

func interact(_player = null) -> void:
	if Global.door_open:
		open()
	else:
		print("Дверь заперта")

func open() -> void:
	if is_open:
		return
	# Простое изменение кадра или запуск анимации
	if sprite:
		# допустим, frame 1 = открыт
		sprite.frame = 1
	if collision_shape:
		collision_shape.disabled = true
	is_open = true
