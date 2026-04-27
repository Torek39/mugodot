extends StaticBody2D

@onready var glitch: TileMapLayer = $glitch
@onready var trash_1: TileMapLayer = $trash_pack_1
@onready var trash_2: TileMapLayer = $trash_pack_2
@onready var trash_3: TileMapLayer = $trash_pack_3
@onready var blocker: CollisionShape2D = $blocker

var is_shaking: bool = true
var is_fixed: bool = false

var origins_x: Dictionary = {}
var phases: Dictionary = {}
var speeds: Dictionary = {}

func _ready() -> void:
	var layers: Array[TileMapLayer] = [glitch, trash_1, trash_2, trash_3]
	var base_speeds: Array = [3.0, 4.5, 6.0, 7.5]
	
	for i in layers.size():
		var layer: TileMapLayer = layers[i]
		if is_instance_valid(layer):
			origins_x[layer] = layer.position.x
			phases[layer] = i * PI * 0.5
			speeds[layer] = base_speeds[i]
	
	if Global.glitch_fixed:
		is_fixed = true
		is_shaking = false
		for layer in layers:
			if is_instance_valid(layer):
				layer.modulate.a = 0.0
		if is_instance_valid(blocker):
			blocker.disabled = true

func _process(_delta: float) -> void:
	if not is_shaking:
		return
	
	var time: float = Time.get_ticks_msec() / 1000.0
	
	for layer in origins_x.keys():
		if not is_instance_valid(layer):
			continue
		
		var t: float = time * speeds[layer] + phases[layer]
		var offset: float = sign(sin(t)) * 3.0
		layer.position.x = origins_x[layer] + offset

func activate() -> void:
	if is_fixed:
		return
	is_fixed = true
	is_shaking = false
	
	for layer in origins_x.keys():
		if is_instance_valid(layer):
			layer.position.x = origins_x[layer]
	
	var layers: Array = []
	for layer in [glitch, trash_1, trash_2, trash_3]:
		if is_instance_valid(layer):
			layers.append(layer)
	
	if layers.is_empty():
		if is_instance_valid(blocker):
			blocker.disabled = true
		return
	
	var tween = create_tween()
	for layer in layers:
		tween.parallel().tween_property(layer, "modulate:a", 0.0, 1.0)
	
	await tween.finished
	if is_instance_valid(blocker):
		blocker.disabled = true
