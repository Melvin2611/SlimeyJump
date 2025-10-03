extends CanvasLayer

@onready var pause_menu = $PauseMenu  # Pfad zu deinem Pause-Menü-Node
@onready var level_coin_label = $LevelCoinLabel  # Label für Level-Münzen
@onready var global_coin_label = $GlobalCoinLabel  # Label für globale Münzen

func _ready() -> void:
	# Verbinde Signale
	if not Global.coin_collected.is_connected(_on_coin_collected):
		Global.coin_collected.connect(_on_coin_collected)
	if not ProgressManager.coin_count_updated.is_connected(_on_coin_count_updated):
		ProgressManager.coin_count_updated.connect(_on_coin_count_updated)
	
	# Initiale Sichtbarkeit
	pause_menu.visible = false
	$DebugMenu.visible = false
	
	# Synchronisiere Global mit ProgressManager
	Global.global_coin_count = ProgressManager.global_coin_count
	# Initiale Anzeige setzen
	update_hud(Global.level_coin_count, ProgressManager.global_coin_count)

func _on_coin_collected(level_count: int, global_count: int):
	update_hud(level_count, global_count)

func _on_coin_count_updated(global_count: int):
	update_hud(Global.level_coin_count, global_count)

func update_hud(level_count: int, global_count: int):
	level_coin_label.text = ": %d/%d" % [level_count, Global.MAX_COINS_PER_LEVEL]
	global_coin_label.text = ": %d" % global_count
	print("HUD aktualisiert: Level Coins = %d/%d, Global Coins = %d" % [level_count, Global.MAX_COINS_PER_LEVEL, global_count])  # Debug-Ausgabe

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Pause-Menü Funktionen
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func _on_pause_button_pressed():
	get_tree().paused = true
	pause_menu.visible = true  # Zeige Menü

func _on_resume_button_pressed():
	get_tree().paused = false
	pause_menu.visible = false

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")  # Zurück zum Hauptmenü

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Debug-Menü Funktionen
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
	ProgressManager.global_coin_count += 5  # Direkt ProgressManager aktualisieren
	Global.global_coin_count = ProgressManager.global_coin_count  # Synchronisiere Global
	ProgressManager.save_progress()  # Speichere den aktualisierten Fortschritt
	ProgressManager.emit_signal("coin_count_updated", ProgressManager.global_coin_count)  # Signal für HUD

func _on_values_button_up() -> void:
	var fps = Engine.get_frames_per_second()
	var mem = Performance.get_monitor(Performance.MEMORY_STATIC) / (1024 * 1024)
	$LabelFPS.text = "FPS: %d | Memory: %.2f MB" % [fps, mem]
	$LabelFPS.show()

func _on_values_button_down() -> void:
	$LabelFPS.hide()

func _on_check_button_button_up() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.max_air_flings = 32000

func _on_check_button_button_down() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.max_air_flings = 1

func _on_reset_button_pressed() -> void:
	ProgressManager.reset_progress()
	print("Fortschritt wurde zurückgesetzt!")

func _on_Coin_reset_button_pressed() -> void:
	Global.level_coin_count = 0
	ProgressManager.global_coin_count = 0  # Direkt ProgressManager zurücksetzen
	Global.global_coin_count = 0  # Synchronisiere Global
	Global.collected_coins = {}  # Löscht alle gesammelten Münz-IDs für alle Levels
	ProgressManager.collected_coins = {}  # Synchronisiere ProgressManager
	ProgressManager.save_progress()  # Speichert die Änderungen in user://progress.save
	ProgressManager.emit_signal("coin_count_updated", 0)  # Signal für HUD
	print("Coins zurückgesetzt!")

func _on_level_unlock_button_pressed() -> void:
	ProgressManager.highest_completed_level = 48  # Setze auf die Anzahl der Levels, um alle freizuschalten
	ProgressManager.save_progress()
	print("Alle Levels freigeschaltet!")
