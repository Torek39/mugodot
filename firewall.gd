extends Node2D

func _ready() -> void:
	var flame1 = get_node_or_null("Flame1")
	var flame2 = get_node_or_null("Flame2")
	var flame3 = get_node_or_null("Flame3")
	
	if flame1:
		flame1.play("wall")
	if flame2:
		flame2.play("fire")
	if flame3:
		flame3.play("fire")

func extinguish() -> void:
	var flame1 = get_node_or_null("Flame1")
	var flame2 = get_node_or_null("Flame2")
	var flame3 = get_node_or_null("Flame3")
	var collision = get_node_or_null("StaticBody2D")
	
	if flame1:
		var tween1 = create_tween()
		tween1.tween_property(flame1, "modulate:a", 0.0, 0.5)
	if flame2:
		var tween2 = create_tween()
		tween2.tween_property(flame2, "modulate:a", 0.0, 0.5)
	if flame3:
		var tween3 = create_tween()
		tween3.tween_property(flame3, "modulate:a", 0.0, 0.5)
	
	await get_tree().create_timer(0.5).timeout
	
	if flame1:
		flame1.queue_free()
	if flame2:
		flame2.queue_free()
	if flame3:
		flame3.queue_free()
	if collision:
		collision.queue_free()
