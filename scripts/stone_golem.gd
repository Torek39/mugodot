extends StaticBody2D

# ==========================
# ЭКСПОРТ
# ==========================
@export var window_golem_path: NodePath

# ==========================
# ВЗАИМОДЕЙСТВИЕ
# ==========================
func interact(_player = null) -> void:
	var controller = get_node_or_null(window_golem_path)
	if controller and controller.has_method("open_window"):
		controller.open_window()
