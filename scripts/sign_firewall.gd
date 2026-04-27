extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Индексация списков",
			"Доступ к элементу списка через [ ]. Индексация начинается с 0. Первый элемент — list[0], второй — list[1], третий — list[2]."
		)
		book_ui.add_page(
			"Примеры индексации",
			"codes = [100, 200, 300]\nkey = codes[0]  # получаем 100\nuse_key(key)  # передаём в функцию\n\nИли короче:\nuse_key(codes[0])"
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
