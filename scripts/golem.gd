extends StaticBody2D

# ==========================
# УЗЛЫ
# ==========================
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	collision_shape.disabled = false
	animated_sprite.play()

# ==========================
# ВЗАИМОДЕЙСТВИЕ
# ==========================
func interact(_player = null) -> void:
	pass  
