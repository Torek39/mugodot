extends StaticBody2D

func _ready() -> void:
	var sprite_a = $SpriteA
	var sprite_b = $SpriteB
	
	if sprite_a:
		sprite_a.play("default")
		sprite_a.speed_scale = 1.0
	
	if sprite_b:
		sprite_b.play("default")
		sprite_b.speed_scale = 0.8
		sprite_b.frame = 3  # разный старт
