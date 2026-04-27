extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Строка ↔ список",
			"split() режет строку в список: 'a,b'.split(',') → ['a','b']. join() склеивает список в строку: '-'.join(['a','b']) → 'a-b'. Разделитель пишется перед точкой."
		)
		book_ui.add_page(
			"Число в текст",
			"str(5) → '5'. Теперь можно сложить: 'уровень' + str(5) → 'уровень5'. Без str() число не прилепить к тексту."
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
