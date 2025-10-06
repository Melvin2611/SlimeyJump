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
@onready var mute_checkbox: CheckBox = $VBoxContainer/Sprite2D/MuteCheckBox
@onready var reset_button: TextureButton = $VBoxContainer/ResetButton
@onready var language_option: OptionButton = $VBoxContainer/LanguageOption
@onready var confirmation_popup = $ConfirmationPopup

# Bus-Indizes
var music_bus_idx: int = -1
var sfx_bus_idx: int = -1

func _ready() -> void:
	# Bus-Indizes ermitteln
	music_bus_idx = AudioServer.get_bus_index(music_bus_name)
	sfx_bus_idx = AudioServer.get_bus_index(sfx_bus_name)

	# Sprache-Optionen füllen
	language_option.clear()
	language_option.add_item("English", 0)
	language_option.add_item("Deutsch", 1)
	language_option.add_item("Français", 2)
	language_option.add_item("Italiano", 3)
	language_option.add_item("Español", 4)
	language_option.add_item("简体中文", 5)
	language_option.add_item("日本語", 6)
	language_option.add_item("Русский", 7)
	
	# Einstellungen laden & anwenden
	load_settings()
	update_ui()
	_apply_music_volume()
	_apply_sfx_volume()
	AudioServer.set_bus_mute(music_bus_idx, mute_enabled)
	AudioServer.set_bus_mute(sfx_bus_idx, mute_enabled)
	Engine.max_fps = fps_limit if fps_limit > 0 else 0
	
	# reset button popup Signale
	confirmation_popup.confirmed.connect(_on_popup_confirmed)
	confirmation_popup.cancelled.connect(_on_popup_cancelled)

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
		Localization.set_language(cfg.get_value("gameplay", "language", "en"))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", music_volume)
	cfg.set_value("audio", "sfx", sfx_volume)
	cfg.set_value("audio", "mute", mute_enabled)
	cfg.set_value("gameplay", "fps", fps_limit)
	cfg.set_value("gameplay", "language", Localization.current_language)
	cfg.save("user://settings.cfg")

# -------------------------
# UI Sync
# -------------------------
func update_ui() -> void:
	music_slider.value = round(music_volume * 100)
	sfx_slider.value = round(sfx_volume * 100)
	mute_checkbox.button_pressed = mute_enabled

	match Localization.current_language:
		"en":
			language_option.select(0)
		"de":
			language_option.select(1)
		"fr":
			language_option.select(2)
		"it":
			language_option.select(3)
		"es":
			language_option.select(4)
		"zh":
			language_option.select(5)
		"ja":
			language_option.select(6)
		"ru":
			language_option.select(7)
		_:
			language_option.select(0) # Fallback auf Englisch

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

func _on_language_option_item_selected(index: int) -> void:
	match index:
		0:
			Localization.set_language("en")
		1:
			Localization.set_language("de")
		2:
			Localization.set_language("fr")
		3:
			Localization.set_language("it")
		4:
			Localization.set_language("es")
		5:
			Localization.set_language("zh")
		6:
			Localization.set_language("ja")
		7:
			Localization.set_language("ru")

	# Alle Labels im Spiel neu laden
	get_tree().call_group("translatable_labels", "update_text")
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


func _on_reset_button_2_pressed() -> void:
	_on_reset_button_pressed()
	confirmation_popup.show()

func _on_popup_confirmed():
	# Logik zum Löschen des Fortschritts
	print("Level-Fortschritt wird gelöscht...")
	ProgressManager.reset_progress()
	print("Level-Fortschritt wurde gelöscht!")
	print("Coin-Fortschritt wird gelöscht...")
	Global.level_coin_count = 0
	ProgressManager.global_coin_count = 0  # Direkt ProgressManager zurücksetzen
	Global.global_coin_count = 0  # Synchronisiere Global
	Global.collected_coins = {}  # Löscht alle gesammelten Münz-IDs für alle Levels
	ProgressManager.collected_coins = {}  # Synchronisiere ProgressManager
	ProgressManager.save_progress()  # Speichert die Änderungen in user://progress.save
	ProgressManager.emit_signal("coin_count_updated", 0)  # Signal für HUD
	print("Coin-Fortschritt wurde gelöscht!")
	print("Save Reset abgeschlossen")

func _on_popup_cancelled():
	print("Abgebrochen")
