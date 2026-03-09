extends Control

func _ready():
	$Panel/VBoxContainer/Slot1.pressed.connect(_on_slot.bind(1))
	$Panel/VBoxContainer/Slot2.pressed.connect(_on_slot.bind(2))
	$Panel/VBoxContainer/Slot3.pressed.connect(_on_slot.bind(3))
	$Panel/VBoxContainer/Slot4.pressed.connect(_on_slot.bind(4))
	$Panel/VBoxContainer/BackButton.pressed.connect(_on_back)
	
	_update_slots()

func _on_slot(slot: int):
	var save = ConfigFile.new()
	if save.load("user://savegame.cfg") != OK:
		return
	
	var scene = save.get_value("slot_" + str(slot), "scene", "")
	if scene == "":
		return
	
	# Загружаем флаги
	Global.door_open = save.get_value("slot_" + str(slot), "door_open", false)
	Global.seals_open = save.get_value("slot_" + str(slot), "seals_open", false)
	Global.luke_open = save.get_value("slot_" + str(slot), "luke_open", false)
	Global.light_on = save.get_value("slot_" + str(slot), "light_on", false)
	Global.bridge_built = save.get_value("slot_" + str(slot), "bridge_built", false)
	Global.rocks_cleared = save.get_value("slot_" + str(slot), "rocks_cleared", false)
	Global.levers_activated = save.get_value("slot_" + str(slot), "levers_activated", false)
	Global.portal_activated = save.get_value("slot_" + str(slot), "portal_activated", false)
	Global.firewall_extinguished = save.get_value("slot_" + str(slot), "firewall_extinguished", false)
	Global.scull_opened = save.get_value("slot_" + str(slot), "scull_opened", false)
	Global.column_moved = save.get_value("slot_" + str(slot), "column_moved", false)
	Global.doorbox_opened = save.get_value("slot_" + str(slot), "doorbox_opened", false)
	
	# Загружаем позицию игрока в Global
	Global.player_spawn_x = save.get_value("slot_" + str(slot), "player_x", 0.0)
	Global.player_spawn_y = save.get_value("slot_" + str(slot), "player_y", 0.0)
	Global.should_load_position = true
	
	Global.input_blocked = false
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", scene)

func _update_slots():
	var save = ConfigFile.new()
	save.load("user://savegame.cfg")
	
	for i in range(1, 5):
		var button = get_node("Panel/VBoxContainer/Slot" + str(i))
		var scene = save.get_value("slot_" + str(i), "scene", "")
		if scene != "":
			button.text = "Slot " + str(i) + ": " + scene.get_file()
		else:
			button.text = "Slot " + str(i) + ": Empty"

func _on_back():
	queue_free()
