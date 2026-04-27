extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Оператор break",
			"Оператор break останавливает цикл досрочно. Когда условие выполнено, цикл прерывается и программа продолжает работу после него.\n\nПример:\nfor i in range(10):\n    if i == 5:\n        break\n# Цикл остановится на 5"
		)
		book_ui.add_page(
			"Оператор break",
			"Пример:\nfor i in range(10):\n    if i == 5:\n        break\n# Цикл остановится на 5"
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
