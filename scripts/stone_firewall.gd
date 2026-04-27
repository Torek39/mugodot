extends StaticBody2D
@export var window_firewall_path: NodePath

func interact(_player = null) -> void:
	var controller = get_node_or_null(window_firewall_path)
	if controller and controller.has_method("open_window"):
		controller.open_window()
