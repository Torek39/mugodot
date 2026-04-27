extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Функция len()",
		    "Функция len() возвращает количество элементов в списке или длину строки.\n\nЗаписывается так:\nlen(название)"
		)
		book_ui.add_page(
			"Функция len()",
		    "len() — количество элементов в списке или символов в строке.\n\nlen(список) → число\n\nПримеры:\nlen([]) → 0\nlen([1,2,3]) → 3\nlen(\"abc\") → 3"
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
