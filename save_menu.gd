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
	save.load("user://savegame.cfg")
	
	# Сохраняем сцену
	save.set_value("slot_" + str(slot), "scene", get_tree().current_scene.scene_file_path)
	
	# Сохраняем позицию игрока
	var player = _find_player()
	if player:
		save.set_value("slot_" + str(slot), "player_x", player.position.x)
		save.set_value("slot_" + str(slot), "player_y", player.position.y)
	
	# Сохраняем флаги головоломок
	save.set_value("slot_" + str(slot), "door_open", Global.door_open)
	save.set_value("slot_" + str(slot), "seals_open", Global.seals_open)
	save.set_value("slot_" + str(slot), "luke_open", Global.luke_open)
	save.set_value("slot_" + str(slot), "light_on", Global.light_on)
	save.set_value("slot_" + str(slot), "bridge_built", Global.bridge_built)
	save.set_value("slot_" + str(slot), "rocks_cleared", Global.rocks_cleared)
	save.set_value("slot_" + str(slot), "levers_activated", Global.levers_activated)
	save.set_value("slot_" + str(slot), "portal_activated", Global.portal_activated)
	save.set_value("slot_" + str(slot), "firewall_extinguished", Global.firewall_extinguished)
	save.set_value("slot_" + str(slot), "scull_opened", Global.scull_opened)
	save.set_value("slot_" + str(slot), "column_moved", Global.column_moved)
	save.set_value("slot_" + str(slot), "doorbox_opened", Global.doorbox_opened)
	
	save.save("user://savegame.cfg")
	_update_slots()

func _find_player() -> Node:
	return _find_node_by_name(get_tree().current_scene, "player")

func _find_node_by_name(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var result = _find_node_by_name(child, node_name)
		if result:
			return result
	return null

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
