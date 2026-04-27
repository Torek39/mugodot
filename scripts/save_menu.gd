extends Control

@onready var confirm_dialog: ConfirmationDialog = $ConfirmationDialog
var pending_slot: int = -1

func _ready():
	$Panel/VBoxContainer/Slot1.pressed.connect(_on_slot_clicked.bind(1))
	$Panel/VBoxContainer/Slot2.pressed.connect(_on_slot_clicked.bind(2))
	$Panel/VBoxContainer/Slot3.pressed.connect(_on_slot_clicked.bind(3))
	$Panel/VBoxContainer/Slot4.pressed.connect(_on_slot_clicked.bind(4))
	$Panel/VBoxContainer/BackButton.pressed.connect(_on_back)
	
	if not confirm_dialog:
		confirm_dialog = ConfirmationDialog.new()
		add_child(confirm_dialog)
		confirm_dialog.dialog_text = "Перезаписать существующее сохранение?"
		confirm_dialog.confirmed.connect(_on_save_confirmed)
	
	_update_slots()

func _on_slot_clicked(slot: int):
	var save = ConfigFile.new()
	save.load("user://savegame.cfg")
	
	var scene = save.get_value("slot_" + str(slot), "scene", "")
	if scene != "":
		pending_slot = slot
		confirm_dialog.popup_centered()
	else:
		_save_to_slot(slot)

func _on_save_confirmed():
	if pending_slot != -1:
		_save_to_slot(pending_slot)
		pending_slot = -1

func _save_to_slot(slot: int):
	var save = ConfigFile.new()
	save.load("user://savegame.cfg")
	
	save.set_value("slot_" + str(slot), "scene", get_tree().current_scene.scene_file_path)
	
	var player = _find_player()
	if player:
		save.set_value("slot_" + str(slot), "player_x", player.position.x)
		save.set_value("slot_" + str(slot), "player_y", player.position.y)
		
	save.set_value("slot_" + str(slot), "book_pages", Global.book_pages)
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
	save.set_value("slot_" + str(slot), "golem_moved", Global.golem_moved)
	save.set_value("slot_" + str(slot), "spikes_stopped", Global.spikes_stopped)
	save.set_value("slot_" + str(slot), "wall_moved", Global.wall_moved)
	save.set_value("slot_" + str(slot), "poison_dispelled", Global.poison_dispelled)
	save.set_value("slot_" + str(slot), "barrier_opened", Global.barrier_opened)
	save.set_value("slot_" + str(slot), "bridge_repaired", Global.bridge_repaired)
	save.set_value("slot_" + str(slot), "wall_detonated", Global.wall_detonated)
	save.set_value("slot_" + str(slot), "guardian_chest_opened", Global.guardian_chest_opened)
	save.set_value("slot_" + str(slot), "teleport_activated", Global.teleport_activated)
	save.set_value("slot_" + str(slot), "glitch_fixed", Global.glitch_fixed)
	
	
	var book_ui = _find_book_ui()
	if book_ui and book_ui.has_method("save_pages"):
		book_ui.save_pages(slot, save)
	
	save.save("user://savegame.cfg")
	_update_slots()

func _find_player() -> Node:
	return _find_node_by_name(get_tree().current_scene, "player")

func _find_book_ui() -> Node:
	return _find_node_by_name(get_tree().root, "BookUI")

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
