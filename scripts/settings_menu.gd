extends Control

func _ready():
	$Panel/VBoxContainer/MasterSlider.value_changed.connect(_on_master_changed)
	$Panel/VBoxContainer/MusicSlider.value_changed.connect(_on_music_changed)
	$Panel/VBoxContainer/BackButton.pressed.connect(_on_back)
	_load_settings()

func _on_master_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))
	_save_settings()

func _on_music_changed(value: float):
	# Проверка чтобы не вылетало если ты забыл создать шину в микшере
	if AudioServer.get_bus_count() > 1:
		AudioServer.set_bus_volume_db(1, linear_to_db(value / 100.0))
		_save_settings()

func _save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master", $Panel/VBoxContainer/MasterSlider.value)
	config.set_value("audio", "music", $Panel/VBoxContainer/MusicSlider.value)
	config.save("user://settings.cfg")

func _load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		$Panel/VBoxContainer/MasterSlider.value = config.get_value("audio", "master", 70)
		$Panel/VBoxContainer/MusicSlider.value = config.get_value("audio", "music", 70)

func _on_back():
	queue_free()
