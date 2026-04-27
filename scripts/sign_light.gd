extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	print("Sign interact called")
	if is_unlocked:
		print("Already unlocked")
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	print("BookUI found: ", book_ui)
	if book_ui and book_ui.has_method("add_page"):
		print("Adding page")
		book_ui.add_page(
			"Оператор +=",
			"Увеличивает значение переменной на указанное число. Запись `x += 5` эквивалентна `x = x + 5`. Используется для накопления значений."
		)
		is_unlocked = true
	else:
		print("BookUI not found or no method")

func _find_book_ui(node: Node) -> Node:
	if node.name == "BookUI":
		return node
	for child in node.get_children():
		var result = _find_book_ui(child)
		if result:
			return result
	return null
