extends StaticBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if sprite:
		sprite.play("default")
		sprite.stop()
		sprite.frame = 0

func open() -> void:
	if not sprite:
		return
	
	sprite.play("default")
	
	await get_tree().create_timer(0.6).timeout
	sprite.stop()
	sprite.frame = 2
	
	# Отключаем только middle_blocker
	var middle = get_node_or_null("middle_blocker")
	if middle and middle is CollisionShape2D:
		middle.disabled = true
