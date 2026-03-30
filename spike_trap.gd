extends Node2D

func _ready() -> void:
	for child in get_children():
		if child is Node2D:
			var anim = child.get_node_or_null("AnimatedSprite2D")
			if anim and anim.sprite_frames:
				anim.play("default")

func stop() -> void:
	for child in get_children():
		if child is Node2D:
			var anim = child.get_node_or_null("AnimatedSprite2D")
			if anim:
				anim.stop()
				anim.frame = 0
	
	var wall = get_node_or_null("spike_wall2")
	if wall:
		wall.queue_free()
