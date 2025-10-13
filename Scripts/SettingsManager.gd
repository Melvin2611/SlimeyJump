extends Node

# Bus-Namen
var music_bus_name: String = "Music"
var sfx_bus_name: String = "SFX"

# Default-Werte
var music_volume: float = 0.8
var sfx_volume: float = 0.8
var fps_limit: int = 60
var mute_enabled: bool = false

# Bus-Indizes
var music_bus_idx: int = -1
var sfx_bus_idx: int = -1

func _ready() -> void:
	# Bus-Indizes ermitteln
	music_bus_idx = AudioServer.get_bus_index(music_bus_name)
	sfx_bus_idx = AudioServer.get_bus_index(sfx_bus_name)
	
	# Einstellungen laden und anwenden
	load_settings()
	apply_settings()

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		music_volume = float(cfg.get_value("audio", "music", music_volume))
		sfx_volume = float(cfg.get_value("audio", "sfx", sfx_volume))
		fps_limit = int(cfg.get_value("gameplay", "fps", fps_limit))
		mute_enabled = bool(cfg.get_value("audio", "mute", mute_enabled))
		Localization.set_language(cfg.get_value("gameplay", "language", "en"))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", music_volume)
	cfg.set_value("audio", "sfx", sfx_volume)
	cfg.set_value("audio", "mute", mute_enabled)
	cfg.set_value("gameplay", "fps", fps_limit)
	cfg.set_value("gameplay", "language", Localization.current_language)
	cfg.save("user://settings.cfg")

func apply_settings() -> void:
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db_safe(music_volume))
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db_safe(sfx_volume))
	AudioServer.set_bus_mute(music_bus_idx, mute_enabled)
	AudioServer.set_bus_mute(sfx_bus_idx, mute_enabled)
	Engine.max_fps = fps_limit if fps_limit > 0 else 0

func linear_to_db_safe(lin: float) -> float:
	if lin <= 0.0001:
		return -80.0
	return linear_to_db(lin)
