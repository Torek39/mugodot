extends Node2D
# ==========================
# УЗЛЫ
# ==========================
@onready var wall1: TileMapLayer = $wall_blocked
@onready var wall2: TileMapLayer = $wall_blocked2
# ==========================
# АНИМАЦИИ ВЗРЫВОВ
# ==========================
var explosions: Array[AnimatedSprite2D] = []
# ==========================
# ИНИЦИАЛИЗАЦИЯ
# ==========================
func _ready() -> void:
	# Собираем все бумы в массив
	for i in range(1, 8):
		var boom = get_node_or_null("boom_" + str(i))
		if boom:
			boom.visible = false
			explosions.append(boom)

# ==========================
# ДЕТОНАЦИЯ
# ==========================
func detonate() -> void:
	# Запускаем взрывы с задержкой 0.5 сек между ними (4 основных, остальные можно вместе)
	for i in range(explosions.size()):
		_trigger_explosion(explosions[i], i * 0.2)
	
	# Затухание стены сразу после первого взрыва
	_fade_walls()

func _trigger_explosion(boom: AnimatedSprite2D, delay: float) -> void:
	if not boom:
		return
	
	# Таймер перед взрывом
	await get_tree().create_timer(delay).timeout
	
	boom.visible = true
	boom.play("default")
	
	# Ждем конца анимации (7 кадров при 7 FPS = 1 секунда)
	await get_tree().create_timer(1.0).timeout
	boom.visible = false

func _fade_walls() -> void:
	# Небольшая задержка перед началом исчезновения стены
	await get_tree().create_timer(0.2).timeout
	
	if wall1:
		var tween1 = create_tween()
		tween1.tween_property(wall1, "modulate:a", 0.0, 0.8)
	
	if wall2:
		var tween2 = create_tween()
		tween2.tween_property(wall2, "modulate:a", 0.0, 0.8)
	
	# Отключаем коллизию после затухания
	await get_tree().create_timer(0.8).timeout
	if wall1:
		wall1.collision_enabled = false
	if wall2:
		wall2.collision_enabled = false
