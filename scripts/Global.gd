extends Node

# Технический флаг — заморозка ГГ (звук не нужен)
var input_blocked := false 

# Технический флаг — режим загрузки (чтобы не проигрывались звуки)
var is_loading := false

var door_open := false:
	set(v):
		if v and !door_open and !is_loading: AudioManager.play_sfx("door_open")
		door_open = v

var golem_moved := false:
	set(v):
		if v and !golem_moved and !is_loading: AudioManager.play_sfx("stone_move", 0.0, 0.5)
		golem_moved = v

var seals_open := false:
	set(v):
		if v and !seals_open and !is_loading: AudioManager.play_sfx("door_open", -5.0, 1.5) 
		seals_open = v

var luke_open := false:
	set(v):
		if v and !luke_open and !is_loading: AudioManager.play_sfx("luke")
		luke_open = v

var light_on := false:
	set(v):
		if v and !light_on and !is_loading: AudioManager.play_sfx("light_on")
		light_on = v

var bridge_built := false:
	set(v):
		if v and !bridge_built and !is_loading: AudioManager.play_sfx("bridge_deploy")
		bridge_built = v

var rocks_cleared := false:
	set(v):
		if v and !rocks_cleared and !is_loading: AudioManager.play_sfx("stone_move", 0.0, 1.3)
		rocks_cleared = v

var levers_activated := false:
	set(v):
		if v and !levers_activated and !is_loading: AudioManager.play_sfx("stone_move", -2.0, 1.8) 
		levers_activated = v

var portal_activated := false:
	set(v):
		if v and !portal_activated and !is_loading: AudioManager.play_sfx("portal")
		portal_activated = v

var firewall_extinguished := false:
	set(v):
		if v and !firewall_extinguished and !is_loading: AudioManager.play_sfx_timed("fire", 4.0)
		firewall_extinguished = v

var scull_opened := false:
	set(v):
		if v and !scull_opened and !is_loading: AudioManager.play_sfx("stone_move", -2.0, 1.6)
		scull_opened = v

var column_moved := false:
	set(v):
		if v and !column_moved and !is_loading: AudioManager.play_sfx("stone_move")
		column_moved = v

var doorbox_opened := false:
	set(v):
		if v and !doorbox_opened and !is_loading: AudioManager.play_sfx("window_open", 0.0, 0.8) 
		doorbox_opened = v

var spikes_stopped := false:
	set(v):
		if v and !spikes_stopped and !is_loading: AudioManager.play_sfx("spike")
		spikes_stopped = v

var wall_moved := false:
	set(v):
		if v and !wall_moved and !is_loading: AudioManager.play_sfx("stone_move", -2.0, 0.9)
		wall_moved = v

var poison_dispelled := false:
	set(v):
		if v and !poison_dispelled and !is_loading: AudioManager.play_sfx("poison_fade")
		poison_dispelled = v

var barrier_opened := false:
	set(v):
		if v and !barrier_opened and !is_loading: AudioManager.play_sfx_timed("barrier_gate", 2.0)
		barrier_opened = v

var bridge_repaired := false:
	set(v):
		if v and !bridge_repaired and !is_loading: AudioManager.play_sfx("bridge_deploy", -2.0, 0.8)
		bridge_repaired = v

var wall_detonated := false:
	set(v):
		if v and !wall_detonated and !is_loading: AudioManager.play_sfx("explosion")
		wall_detonated = v

var guardian_chest_opened := false:
	set(v):
		if v and !guardian_chest_opened and !is_loading: AudioManager.play_sfx("laser")
		guardian_chest_opened = v

var teleport_activated := false:
	set(v):
		if v and !teleport_activated and !is_loading: AudioManager.play_sfx("portal", -2.0, 1.2)
		teleport_activated = v

var glitch_fixed := false:
	set(v):
		if v and !glitch_fixed and !is_loading: AudioManager.play_sfx("glitch")
		glitch_fixed = v

# Для загрузки позиции
var player_spawn_x := 0.0
var player_spawn_y := 0.0
var should_load_position := false
var book_pages: Array = []
