extends Node2D

func _ready() -> void:
	visible = true
	
	var torch1 = get_node_or_null("Torch1")
	var torch2 = get_node_or_null("Torch2")
	var torch3 = get_node_or_null("Torch3")
	
	if torch1:
		torch1.visible = false
	if torch2:
		torch2.visible = false
	if torch3:
		torch3.visible = false

func light_torches() -> void:
	var torch1 = get_node_or_null("Torch1")
	var torch2 = get_node_or_null("Torch2")
	var torch3 = get_node_or_null("Torch3")
	
	if torch1:
		torch1.visible = true
		torch1.play("start")
		await get_tree().create_timer(0.2).timeout
		torch1.play("burn")
		await get_tree().create_timer(0.3).timeout
	
	if torch2:
		torch2.visible = true
		torch2.play("start")
		await get_tree().create_timer(0.2).timeout
		torch2.play("burn")
		await get_tree().create_timer(0.3).timeout
	
	if torch3:
		torch3.visible = true
		torch3.play("start")
		await get_tree().create_timer(0.4).timeout
		torch3.play("burn")
