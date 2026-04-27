extends Node

# Технический флаг — заморозка ГГ (звук не нужен)
var input_blocked := false 

var door_open := false:
	set(v):
		if v and !door_open: AudioManager.play_sfx("door_open")
		door_open = v

var golem_moved := false:
	set(v):
		if v and !golem_moved: AudioManager.play_sfx("stone_move", 0.0, 0.5) # Очень тяжелый звук
		golem_moved = v

var seals_open := false:
	set(v):
		# Звук печатей — используем звук портала, но выше и тише
		if v and !seals_open: AudioManager.play_sfx("door_open", -5.0, 1.5) 
		seals_open = v

var luke_open := false:
	set(v):
		if v and !luke_open: AudioManager.play_sfx("luke")
		luke_open = v

var light_on := false:
	set(v):
		if v and !light_on: AudioManager.play_sfx("light_on")
		light_on = v

var bridge_built := false:
	set(v):
		if v and !bridge_built: AudioManager.play_sfx("bridge_deploy")
		bridge_built = v

var rocks_cleared := false:
	set(v):
		if v and !rocks_cleared: AudioManager.play_sfx("stone_move", 0.0, 1.3) # Осыпание мелких камней
		rocks_cleared = v

var levers_activated := false:
	set(v):
		# Звук рычага: берем камень, но делаем его высоким и коротким
		if v and !levers_activated: AudioManager.play_sfx("stone_move", -2.0, 1.8) 
		levers_activated = v

var portal_activated := false:
	set(v):
		if v and !portal_activated: AudioManager.play_sfx("portal")
		portal_activated = v

var firewall_extinguished := false:
	set(v):
		if v and !firewall_extinguished: AudioManager.play_sfx_timed("fire", 4.0)
		firewall_extinguished = v

var scull_opened := false:
	set(v):
		if v and !scull_opened: AudioManager.play_sfx("stone_move", -2.0, 1.6) # Хруст механизма
		scull_opened = v

var column_moved := false:
	set(v):
		if v and !column_moved: AudioManager.play_sfx("stone_move")
		column_moved = v

var doorbox_opened := false:
	set(v):
		# Металлический щиток — используем звук UI окна, но чуть ниже
		if v and !doorbox_opened: AudioManager.play_sfx("window_open", 0.0, 0.8) 
		doorbox_opened = v

var spikes_stopped := false:
	set(v):
		if v and !spikes_stopped: AudioManager.play_sfx("spike")
		spikes_stopped = v

var wall_moved := false:
	set(v):
		if v and !wall_moved: AudioManager.play_sfx("stone_move", -2.0, 0.9)
		wall_moved = v

var poison_dispelled := false:
	set(v):
		if v and !poison_dispelled: AudioManager.play_sfx("poison_fade")
		poison_dispelled = v

var barrier_opened := false:
	set(v):
		if v and !barrier_opened: AudioManager.play_sfx_timed("barrier_gate", 2.0)
		barrier_opened = v

var bridge_repaired := false:
	set(v):
		if v and !bridge_repaired: AudioManager.play_sfx("bridge_deploy", -2.0, 0.8) # Более тяжелый скрип моста
		bridge_repaired = v

var wall_detonated := false:
	set(v):
		if v and !wall_detonated: AudioManager.play_sfx("explosion")
		wall_detonated = v

var guardian_chest_opened := false:
	set(v):
		if v and !guardian_chest_opened: AudioManager.play_sfx("laser")
		guardian_chest_opened = v

var teleport_activated := false:
	set(v):
		if v and !teleport_activated: AudioManager.play_sfx("portal", -2.0, 1.2)
		teleport_activated = v

var glitch_fixed := false:
	set(v):
		if v and !glitch_fixed: AudioManager.play_sfx("glitch")
		glitch_fixed = v

# Для загрузки позиции
var player_spawn_x := 0.0
var player_spawn_y := 0.0
var should_load_position := false
var book_pages: Array = []
