extends CanvasLayer

@onready var settings_scene = preload("res://scenes/settings_menu.tscn")
@onready var save_scene = preload("res://scenes/save_menu.tscn")
@onready var load_scene = preload("res://scenes/load_menu.tscn")

# Переменная для диалога, которую мы найдем чуть позже
var exit_confirm: ConfirmationDialog
@onready var main_panel = $Panel

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Ищем ExitConfirm рекурсивно, чтобы не париться с путями
	exit_confirm = _find_node_by_name(self, "ExitConfirm")
	
	# Подключаем кнопки (пути должны быть точными от корня CanvasLayer)
	$Panel/VBoxContainer/ResumeButton.pressed.connect(_on_resume)
	$Panel/VBoxContainer/SaveButton.pressed.connect(_on_save)
	$Panel/VBoxContainer/LoadButton.pressed.connect(_on_load)
	$Panel/VBoxContainer/SettingsButton.pressed.connect(_on_settings)
	$Panel/VBoxContainer/ExitButton.pressed.connect(_on_exit_request)
	
	if exit_confirm:
		exit_confirm.confirmed.connect(_on_exit_confirmed)
	else:
		print("ПРЕДУПРЕЖДЕНИЕ: Узел ExitConfirm не найден в сцене PauseMenu!")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var sub_menu_found = false
		for child in get_children():
			if child is Control and child.name != "Panel" and child.name != "ExitConfirm":
				child.queue_free() 
				sub_menu_found = true
		
		if sub_menu_found:
			main_panel.show()
		else:
			toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = visible
	Global.input_blocked = visible
	if visible:
		main_panel.show()

func _on_resume():
	toggle_pause()

func _open_sub_menu(scene: PackedScene):
	if scene:
		var menu = scene.instantiate()
		add_child(menu)
		main_panel.hide()
		menu.tree_exited.connect(func(): if visible: main_panel.show())

func _on_save():
	_open_sub_menu(save_scene)

func _on_load():
	_open_sub_menu(load_scene)

func _on_settings():
	_open_sub_menu(settings_scene)

func _on_exit_request():
	if exit_confirm:
		exit_confirm.popup_centered()
	else:
		# Если так и не нашли, просто выходим
		get_tree().quit()

func _on_exit_confirmed():
	get_tree().quit()

# Вспомогательная функция поиска узла
func _find_node_by_name(root: Node, node_name: String) -> Node:
	if root.name == node_name:
		return root
	for child in root.get_children():
		var found = _find_node_by_name(child, node_name)
		if found:
			return found
	return null
