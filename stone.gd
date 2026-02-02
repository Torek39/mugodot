extends StaticBody2D

@export var puzzle_console_scene: PackedScene

func interact(_player = null) -> void:
	if puzzle_console_scene == null:
		push_error("Puzzle console scene not assigned")
		return
	var console_node = puzzle_console_scene.instantiate()
	get_tree().root.add_child(console_node)
	console_node.call_deferred("setup",
        """door_open = False
if door_open:
    print("Дверь открылась")
else:
    print("Дверь не реагирует")
""",
		"door_open = True",
		func():
			Global.door_open = true
			var door = get_tree().root.get_node("/root/level/door")
			if door and door.has_method("open"):
				door.open()
)
