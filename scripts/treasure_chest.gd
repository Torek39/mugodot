extends StaticBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if sprite:
		sprite.stop()
		sprite.frame = 0

func open() -> void:
	if sprite:
		sprite.play("default")
		# Остаёмся на втором кадре (открыт)
		await get_tree().create_timer(0.5).timeout
		sprite.stop()
		sprite.frame = 1
