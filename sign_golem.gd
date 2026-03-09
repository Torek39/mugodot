extends StaticBody2D

var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Операторы сравнения",
			"Сопоставляют значения переменных и возвращают логический результат `true` или `false` в зависимости от выполнения условия (`==`, `!=`, `<`, `>`, `<=`, `>=`)."
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
