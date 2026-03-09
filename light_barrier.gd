extends StaticBody2D

func remove_barrier() -> void:
	print("Barrier queue_free called")
	queue_free()
