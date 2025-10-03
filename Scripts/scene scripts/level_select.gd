extends Control

@export var Background: ColorRect

@onready var grid_page1: GridContainer = $VBoxContainer/HBoxContainer/GridContainer
@onready var grid_page2: GridContainer = $VBoxContainer/HBoxContainer/GridContainer2
@onready var grid_page3: GridContainer = $VBoxContainer/HBoxContainer/GridContainer3
@onready var left_button: TextureButton = $"Button <"
@onready var right_button: TextureButton = $"Button >"
@onready var popup_purchase: PanelContainer = $PopupPurchase
@onready var popup_label: Label = $PopupPurchase/VBoxContainer/Label
@onready var buy_button: TextureButton = $PopupPurchase/VBoxContainer/BuyButton
@onready var cancel_button: TextureButton = $PopupPurchase/VBoxContainer/CancelButton


var grids: Array[GridContainer]
var current_page: int = 0
var total_pages: int = 3
var slide_distance: float = 1152.0
var selected_bonus_level: int = -1

func _ready():
	# Fülle Grids
	grids = [grid_page1, grid_page2, grid_page3]

	# Buttons verbinden
	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)
	buy_button.pressed.connect(_on_buy_bonus_level)
	cancel_button.pressed.connect(_on_cancel_purchase)

	# Pop-up initial verstecken
	popup_purchase.visible = false

	# Alle Level-Buttons sammeln
	var buttons: Array[BaseButton] = []
	for grid in grids:
		for child in grid.get_children():
			if child is BaseButton:
				buttons.append(child)

	# Buttons sperren & Locks anzeigen
	for i in range(buttons.size()):
		var level_index: int = i
		var locked := not ProgressManager.is_level_unlocked(level_index)
		_set_button_locked_state(buttons[i], locked, level_index)

func _set_button_locked_state(button: BaseButton, locked: bool, level_index: int) -> void:
	# Button deaktivieren
	button.disabled = locked

	# Abdunkeln, wenn gesperrt
	if locked:
		button.modulate = Color(1, 1, 1, 0.5)
	else:
		button.modulate = Color(1, 1, 1, 1)

	# Lock-Icon anzeigen/verstecken (falls vorhanden)
	if button.has_node("LockIcon"):
		button.get_node("LockIcon").visible = locked

	# Für Bonuslevel: Button bleibt klickbar, um Pop-up zu zeigen
	if level_index >= 48 and locked:
		button.disabled = false
		if not button.pressed.is_connected(_show_purchase_popup):
			button.pressed.connect(_show_purchase_popup.bind(level_index))

func _show_purchase_popup(level_index: int):
	if ProgressManager.global_coin_count < 24:
		popup_label.text = "Nicht genug Münzen! (24 benötigt)"
		buy_button.disabled = true
	else:
		popup_label.text = "Level " + str(level_index + 1) + " freischalten für 24 Münzen?"
		buy_button.disabled = false
	selected_bonus_level = level_index
	popup_purchase.visible = true
	if Background:
		Background.show()

func _on_buy_bonus_level():
	if ProgressManager.unlock_bonus_level(selected_bonus_level):
		# Button aktualisieren
		var buttons: Array[BaseButton] = []
		for grid in grids:
			for child in grid.get_children():
				if child is BaseButton:
					buttons.append(child)
		_set_button_locked_state(buttons[selected_bonus_level], false, selected_bonus_level)
		popup_purchase.visible = false
		Background.hide()
	else:
		popup_label.text = "Kauf fehlgeschlagen! Nicht genug Münzen oder Level bereits freigeschaltet."
		buy_button.disabled = true

func _on_cancel_purchase():
	popup_purchase.visible = false
	Background.show()
	selected_bonus_level = -1

func _on_left_pressed():
	var next_page = (current_page - 1 + total_pages) % total_pages
	animate_slide(current_page, next_page, slide_distance, -slide_distance)
	current_page = next_page

func _on_right_pressed():
	var next_page = (current_page + 1) % total_pages
	animate_slide(current_page, next_page, -slide_distance, slide_distance)
	current_page = next_page

func animate_slide(current_idx: int, next_idx: int, current_direction: float, next_start: float):
	grids[next_idx].visible = true
	grids[next_idx].position.x = next_start

	var tween_current = create_tween()
	tween_current.tween_property(grids[current_idx], "position:x", current_direction, 0.5)
	tween_current.tween_callback(func():
		grids[current_idx].visible = false
		grids[current_idx].position.x = 0
	)
	tween_current.set_ease(Tween.EASE_IN_OUT)
	tween_current.set_trans(Tween.TRANS_CUBIC)

	var tween_next = create_tween()
	tween_next.tween_property(grids[next_idx], "position:x", 0, 0.5)
	tween_next.set_ease(Tween.EASE_IN_OUT)
	tween_next.set_trans(Tween.TRANS_CUBIC)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_button_1_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 1/Level1.tscn")

func _on_button_2_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 2/Level2.tscn")

func _on_button_3_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 3/Level3.tscn")

func _on_button_4_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 4/Level4.tscn")

func _on_button_5_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 5/level5.tscn")

func _on_button_6_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W1/Level 6/level6.tscn")

func _on_button_7_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 7/Level7.tscn")

func _on_button_8_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 8/level8.tscn")

func _on_button_9_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 9/Level9.tscn")

func _on_button_10_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 10/Level10.tscn")

func _on_button_11_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 11/level11.tscn")

func _on_button_12_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W2/Level 12/Level12.tscn")

func _on_button_13_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 13/level13.tscn")

func _on_button_14_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 14/Level14.tscn")

func _on_button_15_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 15/Level15.tscn")

func _on_button_16_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 16/Level16.tscn")

func _on_button_17_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 17/level17.tscn")

func _on_button_18_pressed() -> void:
	Global.reset_level_coins()
	get_tree().change_scene_to_file("res://Scenes/Levels/W3/Level 18/Level18.tscn")

func _on_texture_button_19_pressed() -> void:
	if ProgressManager.is_level_unlocked(18):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 19/Level19.tscn")

func _on_texture_button_20_pressed() -> void:
	if ProgressManager.is_level_unlocked(19):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 20/Level20.tscn")

func _on_texture_button_21_pressed() -> void:
	if ProgressManager.is_level_unlocked(20):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 21/Level21.tscn")

func _on_texture_button_22_pressed() -> void:
	if ProgressManager.is_level_unlocked(21):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 22/Level22.tscn")

func _on_texture_button_23_pressed() -> void:
	if ProgressManager.is_level_unlocked(22):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 23/Level23.tscn")

func _on_texture_button_24_pressed() -> void:
	if ProgressManager.is_level_unlocked(23):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W4/Level 24/Level24.tscn")

func _on_texture_button_25_pressed() -> void:
	if ProgressManager.is_level_unlocked(24):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 25/Level25.tscn")

func _on_texture_button_26_pressed() -> void:
	if ProgressManager.is_level_unlocked(25):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 26/Level26.tscn")

func _on_texture_button_27_pressed() -> void:
	if ProgressManager.is_level_unlocked(26):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 27/Level27.tscn")

func _on_texture_button_28_pressed() -> void:
	if ProgressManager.is_level_unlocked(27):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 28/Level28.tscn")

func _on_texture_button_29_pressed() -> void:
	if ProgressManager.is_level_unlocked(28):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 29/Level29.tscn")

func _on_texture_button_30_pressed() -> void:
	if ProgressManager.is_level_unlocked(29):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W5/Level 30/Level30.tscn")

func _on_texture_button_31_pressed() -> void:
	if ProgressManager.is_level_unlocked(30):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 31/Level31.tscn")

func _on_texture_button_32_pressed() -> void:
	if ProgressManager.is_level_unlocked(31):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 32/Level32.tscn")

func _on_texture_button_33_pressed() -> void:
	if ProgressManager.is_level_unlocked(32):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 33/Level33.tscn")

func _on_texture_button_34_pressed() -> void:
	if ProgressManager.is_level_unlocked(33):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 34/Level34.tscn")

func _on_texture_button_35_pressed() -> void:
	if ProgressManager.is_level_unlocked(34):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 35/Level35.tscn")

func _on_texture_button_36_pressed() -> void:
	if ProgressManager.is_level_unlocked(35):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W6/Level 36/Level36.tscn")

func _on_texture_button_37_pressed() -> void:
	if ProgressManager.is_level_unlocked(36):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 37/Level37.tscn")

func _on_texture_button_38_pressed() -> void:
	if ProgressManager.is_level_unlocked(37):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 38/Level38.tscn")

func _on_texture_button_39_pressed() -> void:
	if ProgressManager.is_level_unlocked(38):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 39/Level39.tscn")

func _on_texture_button_40_pressed() -> void:
	if ProgressManager.is_level_unlocked(39):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 40/Level40.tscn")

func _on_texture_button_41_pressed() -> void:
	if ProgressManager.is_level_unlocked(40):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 41/Level41.tscn")

func _on_texture_button_42_pressed() -> void:
	if ProgressManager.is_level_unlocked(41):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W7/Level 42/Level42.tscn")

func _on_texture_button_43_pressed() -> void:
	if ProgressManager.is_level_unlocked(42):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 43/Level43.tscn")

func _on_texture_button_44_pressed() -> void:
	if ProgressManager.is_level_unlocked(43):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 44/Level44.tscn")

func _on_texture_button_45_pressed() -> void:
	if ProgressManager.is_level_unlocked(44):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 45/Level45.tscn")

func _on_texture_button_46_pressed() -> void:
	if ProgressManager.is_level_unlocked(45):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 46/Level46.tscn")

func _on_texture_button_47_pressed() -> void:
	if ProgressManager.is_level_unlocked(46):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 47/Level47.tscn")

func _on_texture_button_48_pressed() -> void:
	if ProgressManager.is_level_unlocked(47):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/W8/Level 48/Level48.tscn")

func _on_texture_button_49_pressed() -> void:
	if ProgressManager.is_level_unlocked(48):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 49/Level49.tscn")

func _on_texture_button_50_pressed() -> void:
	if ProgressManager.is_level_unlocked(49):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 50/Level50.tscn")

func _on_texture_button_51_pressed() -> void:
	if ProgressManager.is_level_unlocked(50):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 51/Level51.tscn")

func _on_texture_button_52_pressed() -> void:
	if ProgressManager.is_level_unlocked(51):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 52/Level52.tscn")

func _on_texture_button_53_pressed() -> void:
	if ProgressManager.is_level_unlocked(52):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 53/Level53.tscn")

func _on_texture_button_54_pressed() -> void:
	if ProgressManager.is_level_unlocked(53):
		Global.reset_level_coins()
		get_tree().change_scene_to_file("res://Scenes/Levels/Bonus/Level 54/Level54.tscn")
