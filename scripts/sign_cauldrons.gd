extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Оператор continue",
			"Оператор continue пропускает текущую итерацию цикла и переходит к следующей. Всё что после continue в этой итерации не выполняется."
		)
		book_ui.add_page(
			"Оператор continue",
			"Пример:\nfor i in range(5):\n    if i == 2:\n        continue\n    print(i)\n# Выведет: 0, 1, 3, 4 (пропустит 2)"
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
