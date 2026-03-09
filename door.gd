extends StaticBody2D

# ==========================
# УЗЛЫ
# ==========================
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# ==========================
# СОСТОЯНИЕ
# ==========================
var is_open: bool = false

# ==========================
# ВЗАИМОДЕЙСТВИЕ
# ==========================
func interact(_player = null) -> void:
	if Global.door_open and not is_open:
		open()

# ==========================
# ОТКРЫТИЕ ДВЕРИ
# ==========================
func open() -> void:
	animated_sprite.frame = 1
	collision_shape.disabled = true
	is_open = true
