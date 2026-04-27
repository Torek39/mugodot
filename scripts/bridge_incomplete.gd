extends StaticBody2D

func _ready() -> void:
	var hidden = get_node_or_null("bridge_hidden")
	if hidden:
		hidden.modulate.a = 0.0
		hidden.visible = true

func repair() -> void:
	var hidden_part = get_node_or_null("bridge_hidden")
	
	# Отключаем коллизию 
	collision_layer = 0
	collision_mask = 0
	
	# Анимируем проявление целого моста поверх разрушенного
	if hidden_part:
		var tween = create_tween()
		tween.tween_property(hidden_part, "modulate:a", 1.0, 1.0)
