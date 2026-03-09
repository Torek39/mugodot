extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Функции def",
			"Функция — группа команд под одним именем. Создаётся через def название(): и вызывается по имени. Позволяет не повторять код и организовать его логически. Пример:\ndef activate():\n    step_one()\n    step_two()\n\nactivate()  # выполнит обе команды"
		)
		is_unlocked = true

func _find_book_ui(node: Node) -> Node:
	if node.name == "BookUI":
		return node
	for child in node.get_children():
		var result = _find_book_ui(child)
		if result:
			return result
	return null
