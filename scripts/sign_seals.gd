extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Логическое И (and)",
			"Используется для проверки нескольких условий одновременно. Результат будет True только в том случае, если оба условия (и левое, и правое) истинны. Если хотя бы одно из них False, то и весь результат будет False."
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
