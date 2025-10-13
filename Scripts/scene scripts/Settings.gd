extends Control
signal settings_closed

# UI-Referenzen
@onready var music_slider: HSlider = $VBoxContainer/Sprite2D2/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer/Sprite2D3/SfxSlider
@onready var mute_checkbox: CheckBox = $VBoxContainer/Sprite2D/MuteCheckBox
@onready var reset_button: TextureButton = $VBoxContainer/ResetButton
@onready var language_option: OptionButton = $VBoxContainer/LanguageOption
@onready var confirmation_popup = $ConfirmationPopup

func _ready() -> void:
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
	
	# UI mit aktuellen Werten synchronisieren
	update_ui()
	
	# Signale für Reset-Popup
	confirmation_popup.confirmed.connect(_on_popup_confirmed)
	confirmation_popup.cancelled.connect(_on_popup_cancelled)

func update_ui() -> void:
	music_slider.value = round(SettingsManager.music_volume * 100)
	sfx_slider.value = round(SettingsManager.sfx_volume * 100)
	mute_checkbox.button_pressed = SettingsManager.mute_enabled
	
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
			language_option.select(0)

# Signal-Handler
func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.music_volume = clamp(value / 100.0, 0.0, 1.0)
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.sfx_volume = clamp(value / 100.0, 0.0, 1.0)
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

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
	get_tree().call_group("translatable_labels", "update_text")
	SettingsManager.save_settings()

func _on_mute_check_box_toggled(button_pressed: bool) -> void:
	SettingsManager.mute_enabled = button_pressed
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_reset_button_pressed() -> void:
	SettingsManager.music_volume = 0.8
	SettingsManager.sfx_volume = 0.8
	SettingsManager.fps_limit = 60
	SettingsManager.mute_enabled = false
	update_ui()
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_reset_button_2_pressed() -> void:
	_on_reset_button_pressed()
	confirmation_popup.show()

func _on_popup_confirmed():
	print("Level-Fortschritt wird gelöscht...")
	ProgressManager.reset_progress()
	print("Level-Fortschritt wurde gelöscht!")
	print("Coin-Fortschritt wird gelöscht...")
	Global.level_coin_count = 0
	ProgressManager.global_coin_count = 0
	Global.global_coin_count = 0
	Global.collected_coins = {}
	ProgressManager.collected_coins = {}
	ProgressManager.save_progress()
	ProgressManager.emit_signal("coin_count_updated", 0)
	print("Coin-Fortschritt wurde gelöscht!")
	print("Save Reset abgeschlossen")

func _on_popup_cancelled():
	print("Abgebrochen")
