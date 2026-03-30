extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Метод split()",
			"Разделяет строку на список. s = 'a,b,c', s.split(',') → ['a', 'b', 'c']. Доступ: список[0] вернёт 'a'."
		)
		book_ui.add_page(
			"Цикл for и int()",
			"for x in список: — перебирает элементы. Если список = ['16', '9'], то x сначала '16', потом '9'. int(x) превращает в число."
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
