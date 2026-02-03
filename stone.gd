extends StaticBody2D

@export var window_path: NodePath

func interact(_player = null) -> void:
	var controller = get_node_or_null(window_path)
	if controller:
		if controller.has_method("open_window"):
			controller.open_window()
		else:
			print("window controller has no open_window() at path:", window_path)
	else:
		print("window controller not found at path:", window_path)
