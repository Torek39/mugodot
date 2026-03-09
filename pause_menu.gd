extends CanvasLayer

@onready var settings_scene = preload("res://settings_menu.tscn")
@onready var save_scene = preload("res://save_menu.tscn")
@onready var load_scene = preload("res://load_menu.tscn")

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$Panel/VBoxContainer/ResumeButton.pressed.connect(_on_resume)
	$Panel/VBoxContainer/SaveButton.pressed.connect(_on_save)
	$Panel/VBoxContainer/LoadButton.pressed.connect(_on_load)
	$Panel/VBoxContainer/SettingsButton.pressed.connect(_on_settings)
	$Panel/VBoxContainer/ExitButton.pressed.connect(_on_exit)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = visible
	Global.input_blocked = visible

func _on_resume():
	toggle_pause()

func _on_save():
	var menu = save_scene.instantiate()
	add_child(menu)

func _on_load():
	var menu = load_scene.instantiate()
	add_child(menu)

func _on_settings():
	var menu = settings_scene.instantiate()
	add_child(menu)

func _on_exit():
	get_tree().quit()
