extends Node

func _ready():
	get_tree().node_added.connect(_on_scene_loaded)

func _on_scene_loaded(node: Node):
	if node == get_tree().current_scene:
		call_deferred("apply_state")

func apply_state():
	var scene = get_tree().current_scene
	
	# LEVEL 1
	if Global.door_open:
		_set_door_open(scene, "door")
	
	if Global.golem_moved:
		var golem = _find(scene, "Golem")
		if golem:
			golem.position.x -= 30
			if golem.has_node("CollisionShape2D"):
				golem.get_node("CollisionShape2D").disabled = true
	
	if Global.seals_open:
		_set_door_open(scene, "door_seals")
	
	if Global.luke_open:
		var luke = _find(scene, "luke")
		if luke and luke.has_node("AnimatedSprite2D"):
			luke.get_node("AnimatedSprite2D").frame = 3
		if luke and luke.has_node("CollisionShape2D"):
			luke.get_node("CollisionShape2D").disabled = true
	
	# LEVEL 2
	if Global.light_on:
		var barrier = _find(scene, "light_barrier")
		if barrier: barrier.queue_free()
		
		var darkness = _find(scene, "Darkness")
		if darkness: darkness.queue_free()
	
	if Global.bridge_built:
		var bridge = _find(scene, "bridge")
		if bridge: bridge.visible = true
		
		var barrier = _find(scene, "bridge_barrier")
		if barrier: barrier.queue_free()
	
	if Global.rocks_cleared:
		var roks = _find(scene, "roks")
		if roks: roks.position.y += 55
	
	if Global.levers_activated:
		var lever2 = _find(scene, "lever2")
		var lever3 = _find(scene, "lever3")
		if lever2 and lever2.has_node("AnimatedSprite2D"):
			lever2.get_node("AnimatedSprite2D").frame = 4
		if lever3 and lever3.has_node("AnimatedSprite2D"):
			lever3.get_node("AnimatedSprite2D").frame = 4
		
		var statue = _find(scene, "statue")
		var statue2 = _find(scene, "statue2")
		if statue: statue.position.x -= 20
		if statue2: statue2.position.x += 20
	
	if Global.portal_activated:
		var platform1 = _find(scene, "platform1")
		var platform2 = _find(scene, "platform2")
		var platform3 = _find(scene, "platform3")
		if platform1: platform1.visible = true
		if platform2: platform2.visible = true
		if platform3: platform3.visible = true
		
		var portal = _find(scene, "portal")
		if portal:
			portal.visible = true
			if portal.has_node("AnimatedSprite2D"):
				portal.get_node("AnimatedSprite2D").frame = 7
	var spike_trap = _find(scene, "SpikeTrap")
	if spike_trap and spike_trap.has_method("stop"):
		spike_trap.stop()
	
	# LEVEL 3
	if Global.firewall_extinguished:
		var firewall = _find(scene, "FireWall")
		if firewall: firewall.queue_free()
	
	if Global.scull_opened:
		var scull = _find(scene, "scull")
		if scull: scull.position.y = 24
		
		var torch_group = _find(scene, "TorchGroup")
		if torch_group:
			torch_group.visible = true
			var torch1 = torch_group.get_node_or_null("Torch1")
			var torch2 = torch_group.get_node_or_null("Torch2")
			var torch3 = torch_group.get_node_or_null("Torch3")
			if torch1: torch1.play("burn")
			if torch2: torch2.play("burn")
			if torch3: torch3.play("burn")
	
	if Global.column_moved:
		var column = _find(scene, "Column")
		var runa = _find(scene, "runa")
		if column: column.position = Vector2(32, 14)
		if runa: runa.visible = true
	
	if Global.doorbox_opened:
		var box1 = _find(scene, "box1")
		var box2 = _find(scene, "box2")
		var box3 = _find(scene, "box3")
		if box1: box1.position.y = -63
		if box2: box2.position.y = -63
		if box3: box3.position.y = -63
		
		_set_door_open(scene, "door_box")
	
	if Global.wall_moved:
		var wall = _find(scene, "cauldron_wall")
		if wall:
			wall.position = Vector2(11.0, 80.0)
			
	if Global.poison_dispelled:
		var cloud = _find(scene, "poison_cloud")
		if cloud:
			cloud.queue_free()
			
	if Global.barrier_opened:
		var barrier = _find(scene, "barrier_gate")
		if barrier and barrier.has_method("open"):
			barrier.open()
		var npc = _find(scene, "npc_gatekeeper")
		if npc and npc.has_method("set_solved"):
			npc.set_solved()

func _set_door_open(scene: Node, name: String):
	var door = _find(scene, name)
	if door and door.has_node("AnimatedSprite2D"):
		door.get_node("AnimatedSprite2D").frame = 1
		if door.has_node("CollisionShape2D"):
			door.get_node("CollisionShape2D").disabled = true

func _find(node: Node, name: String) -> Node:
	if node.name == name: return node
	for child in node.get_children():
		var r = _find(child, name)
		if r: return r
	return null
