extends Node

# ==========================
# УЗЛЫ
# ==========================
@onready var music_player: AudioStreamPlayer = $MusicPlayer

# ==========================
# БИБЛИОТЕКА ЗВУКОВ
# ==========================
var sfx_library: Dictionary = {
	"click":        "res://assets/audio/sfx/click.wav",
	"open_paper":   "res://assets/audio/sfx/open_paper.wav",
	"window_open":  "res://assets/audio/sfx/window_open.mp3",
	"error":        "res://assets/audio/sfx/error.mp3",
	"success":      "res://assets/audio/sfx/success.mp3",
	"notification": "res://assets/audio/sfx/notification.mp3",
	# Объекты
	"stone_move":   "res://assets/audio/sfx/stone_move.wav",
	"door_open":    "res://assets/audio/sfx/door_open.mp3",
	"luke":         "res://assets/audio/sfx/luke.wav",
	"light_on":     "res://assets/audio/sfx/light_on.wav",
	"bridge_deploy":"res://assets/audio/sfx/bridge_deploy.wav",
	"portal":       "res://assets/audio/sfx/portal.wav",
	"spike":        "res://assets/audio/sfx/spike.wav",
	"poison_fade":  "res://assets/audio/sfx/poison_fade.mp3",
	"explosion":    "res://assets/audio/sfx/explosion.wav",
	"laser":        "res://assets/audio/sfx/laser.wav",
	"glitch":       "res://assets/audio/sfx/glitch.wav",
	"walk":         "res://assets/audio/sfx/walk.wav", # ход 
	"fire":         "res://assets/audio/sfx/fire.wav",      #  4 сек
	"barrier_gate": "res://assets/audio/sfx/barrier_gate.wav",  #  3 сек
}

# ==========================
# ВОСПРОИЗВЕДЕНИЕ МУЗЫКИ
# ==========================
func play_music(path: String) -> void:
	if music_player.stream and music_player.stream.resource_path == path:
		return
	music_player.stream = load(path)
	music_player.play()

func stop_music() -> void:
	music_player.stop()

# ==========================
# ВОСПРОИЗВЕДЕНИЕ SFX
# ==========================
func play_sfx(sound_name: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	if not sfx_library.has(sound_name):
		push_error("AudioManager: звук не найден — " + sound_name)
		return

	var p := AudioStreamPlayer.new()
	add_child(p)
	p.stream = load(sfx_library[sound_name])
	p.bus = "SFX"
	p.volume_db = volume_db
	p.pitch_scale = pitch
	p.play()
	p.finished.connect(p.queue_free)

# ==========================
# SFX С ОБРЕЗКОЙ ПО ВРЕМЕНИ
# ==========================
func play_sfx_timed(sound_name: String, duration: float, volume_db: float = 0.0) -> void:
	if not sfx_library.has(sound_name):
		push_error("AudioManager: звук не найден — " + sound_name)
		return

	var p := AudioStreamPlayer.new()
	add_child(p)
	p.stream = load(sfx_library[sound_name])
	p.bus = "SFX"
	p.volume_db = volume_db
	p.play()

	var tween := create_tween()
	tween.tween_interval(duration - 0.3)
	tween.tween_property(p, "volume_db", -80.0, 0.3)
	tween.tween_callback(p.queue_free)
