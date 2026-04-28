extends Control

var delete_slot: int = -1

func _ready():
	$Panel/VBoxContainer/Slot1.pressed.connect(_on_slot.bind(1))
	$Panel/VBoxContainer/Slot2.pressed.connect(_on_slot.bind(2))
	$Panel/VBoxContainer/Slot3.pressed.connect(_on_slot.bind(3))
	$Panel/VBoxContainer/Slot4.pressed.connect(_on_slot.bind(4))
	$Panel/VBoxContainer/BackButton.pressed.connect(_on_back)
	
	$Panel/VBoxContainer/Slot1.gui_input.connect(_on_slot_input.bind(1))
	$Panel/VBoxContainer/Slot2.gui_input.connect(_on_slot_input.bind(2))
	$Panel/VBoxContainer/Slot3.gui_input.connect(_on_slot_input.bind(3))
	$Panel/VBoxContainer/Slot4.gui_input.connect(_on_slot_input.bind(4))
	
	var confirm_dialog = ConfirmationDialog.new()
	confirm_dialog.name = "DeleteConfirm"
	add_child(confirm_dialog)
	confirm_dialog.dialog_text = "Удалить этот сохранённый файл?"
	confirm_dialog.confirmed.connect(_on_delete_confirmed)
	
	_update_slots()

func _on_slot_input(event: InputEvent, slot: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		delete_slot = slot
		var dialog = get_node("DeleteConfirm")
		if dialog:
			dialog.popup_centered()

func _on_delete_confirmed():
	if delete_slot == -1:
		return
	
	var save = ConfigFile.new()
	save.load("user://savegame.cfg")
	
	save.erase_section("slot_" + str(delete_slot))
	save.save("user://savegame.cfg")
	
	delete_slot = -1
	_update_slots()

func _on_slot(slot: int):
	var save = ConfigFile.new()
	if save.load("user://savegame.cfg") != OK:
		return
	
	var scene = save.get_value("slot_" + str(slot), "scene", "")
	if scene == "":
		return
		
	# ВРУБАЕМ ТИШИНУ ПЕРЕД ЗАГРУЗКОЙ ФЛАГОВ
	Global.is_loading = true
		
	Global.book_pages = save.get_value("slot_" + str(slot), "book_pages", [])
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
	Global.golem_moved = save.get_value("slot_" + str(slot), "golem_moved", false)
	Global.spikes_stopped = save.get_value("slot_" + str(slot), "spikes_stopped", false)
	Global.wall_moved = save.get_value("slot_" + str(slot), "wall_moved", false)
	Global.poison_dispelled = save.get_value("slot_" + str(slot), "poison_dispelled", false)
	Global.barrier_opened = save.get_value("slot_" + str(slot), "barrier_opened", false)
	Global.bridge_repaired = save.get_value("slot_" + str(slot), "bridge_repaired", false)
	Global.wall_detonated = save.get_value("slot_" + str(slot), "wall_detonated", false)
	Global.guardian_chest_opened = save.get_value("slot_" + str(slot), "guardian_chest_opened", false)
	Global.teleport_activated = save.get_value("slot_" + str(slot), "teleport_activated", false)
	Global.glitch_fixed = save.get_value("slot_" + str(slot), "glitch_fixed", false)
	
	# ВЫРУБАЕМ ТИШИНУ, ФЛАГИ ЗАГРУЖЕНЫ
	Global.is_loading = false
	
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
