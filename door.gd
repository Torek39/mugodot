extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func interact(_player = null) -> void:
	if Global.door_open:
		print("Дверь открылась")
		# Здесь можно добавить анимацию или звук, если нужно
	else:
		print("Дверь заперта")

func open() -> void:
	if animated_sprite:
		animated_sprite.frame = 1  # Переключаем на кадр открытой двери (адаптируй, если frames другие)
	collision_shape.disabled = true  # Отключаем коллайдер, чтобы пройти
	print("Дверь разблокирована")
