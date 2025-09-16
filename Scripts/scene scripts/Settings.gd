extends Control
signal settings_closed

# Bus-Namen im Inspector anpassbar
@export var music_bus_name: String = "Music"
@export var sfx_bus_name: String = "SFX"

# Default-Werte
var music_volume: float = 0.8
var sfx_volume: float = 0.8
var fps_limit: int = 60  # 0 = unbegrenzt
var mute_enabled: bool = false

# UI-Referenzen
@onready var music_slider: HSlider = $VBoxContainer/Sprite2D2/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer/Sprite2D3/SfxSlider
@onready var fps_option: OptionButton = $VBoxContainer/FpsOption
@onready var mute_checkbox: CheckBox = $VBoxContainer/Sprite2D/MuteCheckBox
@onready var reset_button: TextureButton = $VBoxContainer/ResetButton

# Bus-Indizes
var music_bus_idx: int = -1
var sfx_bus_idx: int = -1

func _ready() -> void:
	# Bus-Indizes ermitteln
	music_bus_idx = AudioServer.get_bus_index(music_bus_name)
	sfx_bus_idx = AudioServer.get_bus_index(sfx_bus_name)

	# FPS-Optionen füllen
	fps_option.clear()
	fps_option.add_item("30 FPS", 30)
	fps_option.add_item("60 FPS", 60)
	fps_option.add_item("Unbegrenzt", 0)

	# Einstellungen laden & anwenden
	load_settings()
	update_ui()
	_apply_music_volume()
	_apply_sfx_volume()
	AudioServer.set_bus_mute(music_bus_idx, mute_enabled)
	AudioServer.set_bus_mute(sfx_bus_idx, mute_enabled)
	Engine.max_fps = fps_limit if fps_limit > 0 else 0

# -------------------------
# Laden / Speichern
# -------------------------
func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		music_volume = float(cfg.get_value("audio", "music", music_volume))
		sfx_volume = float(cfg.get_value("audio", "sfx", sfx_volume))
		fps_limit = int(cfg.get_value("gameplay", "fps", fps_limit))
		mute_enabled = bool(cfg.get_value("audio", "mute", mute_enabled))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", music_volume)
	cfg.set_value("audio", "sfx", sfx_volume)
	cfg.set_value("audio", "mute", mute_enabled)
	cfg.set_value("gameplay", "fps", fps_limit)
	cfg.save("user://settings.cfg")

# -------------------------
# UI Sync
# -------------------------
func update_ui() -> void:
	music_slider.value = round(music_volume * 100)
	sfx_slider.value = round(sfx_volume * 100)
	mute_checkbox.button_pressed = mute_enabled

	for i in range(fps_option.get_item_count()):
		if fps_option.get_item_id(i) == fps_limit:
			fps_option.select(i)
			break

# -------------------------
# Hilfsfunktionen
# -------------------------
func _linear_to_db_safe(lin: float) -> float:
	if lin <= 0.0001:
		return -80.0 # stumm
	return linear_to_db(lin)

func _apply_music_volume() -> void:
	if music_bus_idx >= 0:
		AudioServer.set_bus_volume_db(music_bus_idx, _linear_to_db_safe(music_volume))

func _apply_sfx_volume() -> void:
	if sfx_bus_idx >= 0:
		AudioServer.set_bus_volume_db(sfx_bus_idx, _linear_to_db_safe(sfx_volume))

# -------------------------
# Signal-Handler
# -------------------------
func _on_music_slider_value_changed(value: float) -> void:
	music_volume = clamp(value / 100.0, 0.0, 1.0)
	_apply_music_volume()
	save_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_volume = clamp(value / 100.0, 0.0, 1.0)
	_apply_sfx_volume()
	save_settings()

func _on_fps_option_item_selected(id: int) -> void:
	fps_limit = id
	Engine.max_fps = fps_limit if fps_limit > 0 else 0
	save_settings()

func _on_mute_check_box_toggled(button_pressed: bool) -> void:
	mute_enabled = button_pressed
	AudioServer.set_bus_mute(music_bus_idx, mute_enabled)
	AudioServer.set_bus_mute(sfx_bus_idx, mute_enabled)
	save_settings()

func _on_reset_button_pressed() -> void:
	music_volume = 0.8
	sfx_volume = 0.8
	fps_limit = 60
	mute_enabled = false
	update_ui()
	_apply_music_volume()
	_apply_sfx_volume()
	AudioServer.set_bus_mute(music_bus_idx, mute_enabled)
	AudioServer.set_bus_mute(sfx_bus_idx, mute_enabled)
	Engine.max_fps = fps_limit
	save_settings()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
