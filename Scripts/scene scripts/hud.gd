extends CanvasLayer

@onready var pause_menu = $PauseMenu  # Pfad zu deinem Pause-Menü-Node
func _on_pause_button_pressed():
	get_tree().paused = true
	pause_menu.visible = true  # Zeige Menü

# Für den Resume-Button im Menü:
func _on_resume_button_pressed():
	get_tree().paused = false
	pause_menu.visible = false

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
# Für Quit-Button:
func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")  # Zurück zum Hauptmenü
	
@onready var coin_label: Label = $CoinLabel  # Referenz zum Label

func _ready() -> void:
	Global.coin_collected.connect(_on_coin_collected)  # Signal vom Global-Skript verbinden
	pause_menu.visible = false
	$DebugMenu.visible = false
	update_hud()  # Initial anzeigen

func _on_coin_collected(_new_count: int) -> void:
	update_hud()

func update_hud() -> void:
	coin_label.text = ": %d" % [Global.coin_count]
	if Global.coin_count == Global.MAX_COINS:
		coin_label.add_theme_color_override("font_color", Color(1, 1, 0.3))  # Rot färben
	else:
		coin_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Weiß (Standard)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ab hier begintt das Debug Menu:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func _on_button_pressed() -> void:
	$DebugMenu.visible = true

func _on_teleport_button_pressed() -> void:
	get_tree().paused = false
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var x = $DebugMenu/VBoxContainer/HBoxContainer/LineEditX.text.to_float()
		var y = $DebugMenu/VBoxContainer/HBoxContainer/LineEditY.text.to_float()
		player.global_position = Vector2(x, y)
	get_tree().paused = true

func _on_exit_debug_pressed() -> void:
	$DebugMenu.visible = false

func _on_invincible_button_up() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.collision_layer = 1
		player.collision_mask = 1

func _on_invincible_button_down() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.collision_layer = 1
		player.collision_mask = 2


func _on_add_coins_pressed() -> void:
	Global.coin_count += 1
	update_hud()

func _on_values_button_up() -> void:
	var fps = Engine.get_frames_per_second()
	var mem = Performance.get_monitor(Performance.MEMORY_STATIC) / (1024 * 1024)
	$LabelFPS.text = "FPS: %d | Memory: %.2f MB" % [fps, mem]
	$LabelFPS.show()
	
func _on_values_button_down() -> void:
	$LabelFPS.hide()

func _on_check_button_button_up() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.max_air_flings = 32000


func _on_check_button_button_down() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	player.max_air_flings = 1
