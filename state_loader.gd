extends Node

func _ready():
	get_tree().node_added.connect(_on_scene_loaded)

func _on_scene_loaded(node: Node):
	if node == get_tree().current_scene:
		call_deferred("apply_state")

func apply_state():
	var scene = get_tree().current_scene
	
	if Global.bridge_built:
		var bridge = _find(scene, "bridge")
		if bridge: bridge.visible = true
	
	if Global.rocks_cleared:
		var roks = _find(scene, "roks")
		if roks: roks.position.y += 55
	
	if Global.levers_activated:
		var statue1 = _find(scene, "statue")
		var statue2 = _find(scene, "statue2")
		if statue1: statue1.position.x -= 20
		if statue2: statue2.position.x += 20
	
	if Global.scull_opened:
		var scull = _find(scene, "scull")
		if scull: scull.position.y = 24
	
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

func _find(node: Node, name: String) -> Node:
	if node.name == name: return node
	for child in node.get_children():
		var r = _find(child, name)
		if r: return r
	return null
