extends StaticBody2D

@export var page_id: int = 1

var is_unlocked: bool = false

var pages_data = {
	1: {
		"title": "Булевы значения",
		"text": "В программировании существует тип данных bool (булев).\nОн принимает только два значения:\n- True — истина\n- False — ложь"
	},
	2: {
		"title": "Операторы сравнения",
		"text": "Операторы сравнения проверяют условия:\n\n> — больше\n< — меньше\n>= — больше или равно\n\nПример:\nif current_power > required_power:\n    # код выполнится"
	}
}

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		var data = pages_data.get(page_id)
		if data:
			book_ui.add_page(data["title"], data["text"])
			is_unlocked = true

func _find_book_ui(node: Node) -> Node:
	if node.name == "BookUI":
		return node
	for child in node.get_children():
		var result = _find_book_ui(child)
		if result:
			return result
	return null
