extends Control

@onready var load_menu_scene = preload("res://load_menu.tscn")

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play)
	$VBoxContainer/LoadButton.pressed.connect(_on_load)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit)

func _on_play():
	Global.door_open = false
	Global.seals_open = false
	Global.luke_open = false
	Global.light_on = false
	Global.bridge_built = false
	Global.rocks_cleared = false
	Global.levers_activated = false
	Global.portal_activated = false
	Global.firewall_extinguished = false
	Global.scull_opened = false
	Global.column_moved = false
	Global.doorbox_opened = false
	Global.golem_moved = false
	Global.spikes_stopped = false
	Global.wall_moved = false
	Global.poison_dispelled = false
	Global.barrier_opened = false
	
	
	var book_ui = get_node_or_null("/root/BookUI")
	if book_ui:
		book_ui.pages.clear()
	
	get_tree().change_scene_to_file("res://level/level.tscn")

func _on_load():
	var menu = load_menu_scene.instantiate()
	add_child(menu)

func _on_exit():
	get_tree().quit()
