extends StaticBody2D
var is_unlocked: bool = false

func interact(_player = null) -> void:
	if is_unlocked:
		return
	
	await get_tree().process_frame
	
	var book_ui = _find_book_ui(get_tree().current_scene)
	if book_ui and book_ui.has_method("add_page"):
		book_ui.add_page(
			"Словари {}",
			"Словарь хранит пары ключ-значение. Ключ в кавычках, значение — число. Создание: {\"золото\": 10, \"серебро\": 5}. Доступ: словарь[\"золото\"] вернёт 10."
		)
		book_ui.add_page(
			"Пример словаря",
			"resources = {\"дерево\": 8, \"камень\": 12}\nresources[\"железо\"] = 5\ntotal = resources[\"дерево\"] + resources[\"камень\"]\n# total будет 20"
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
