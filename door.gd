extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_open: bool = false

func interact(_player = null) -> void:
	if Global.door_open:
		print("Дверь открылась")
		if not is_open:
			open()  # Вызываем визуальное открытие при взаимодействии, если ещё не открыто
	else:
		print("Дверь заперта")

func open() -> void:
	print("Opening door visually!")
	if animated_sprite:
		animated_sprite.frame = 1
	else:
		print("No animated_sprite in door")
	if collision_shape:
		collision_shape.disabled = true
	else:
		print("No collision_shape in door")
	is_open = true
