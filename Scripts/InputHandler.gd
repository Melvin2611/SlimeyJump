extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var level_coin_label = $LevelCoinLabel
@onready var global_coin_label = $GlobalCoinLabel
@onready var debug_menu = $DebugMenu

# Variablen für Touch-Erkennung
var touch_left_start_time: float = 0.0
var touch_right_start_time: float = 0.0
var is_touching_left: bool = false
var is_touching_right: bool = false
const TOUCH_HOLD_TIME: float = 3.0  # 3 Sekunden
const CORNER_SIZE: float = 100.0    # Größe der oberen Ecken (in Pixeln)

func _ready() -> void:
	# Verbinde Signale
	if not Global.coin_collected.is_connected(_on_coin_collected):
		Global.coin_collected.connect(_on_coin_collected)
	if not ProgressManager.coin_count_updated.is_connected(_on_coin_count_updated):
		ProgressManager.coin_count_updated.connect(_on_coin_count_updated)

	# Initiale Sichtbarkeit
	pause_menu.visible = false
	if debug_menu:
		debug_menu.visible = false
		print("DebugMenu gefunden und initial unsichtbar gesetzt")
	else:
		print("FEHLER: DebugMenu Node nicht gefunden! Überprüfe den Szenenbaum.")

	# Synchronisiere Global mit ProgressManager
	Global.global_coin_count = ProgressManager.global_coin_count

	# Initiale Anzeige setzen
	update_hud(Global.level_coin_count, ProgressManager.global_coin_count)

	# Stelle sicher, dass Input verarbeitet wird
	set_process_input(true)  # Ersetze unhandled_input mit input für bessere Kontrolle
	print("Input-Verarbeitung aktiviert")

func _input(event: InputEvent) -> void:
	# Prüfe nur Key-Events während der Pause
	if event is InputEventKey and event.pressed and get_tree().paused:
		if event.keycode == KEY_F8:
			print("F8 während Pause erkannt")
			if debug_menu:
				print("Öffne Debug-Menü mit F8")
				debug_menu.visible = true
			else:
				print("FEHLER: debug_menu ist null")
		elif event.keycode == KEY_D:
			print("D während Pause erkannt")
			if debug_menu:
				print("Öffne Debug-Menü mit D")
				debug_menu.visible = true
			else:
				print("FEHLER: debug_menu ist null")

	# Touch-Erkennung für Mobile
	if event is InputEventScreenTouch:
		var touch_pos = event.position
		var viewport_size = get_viewport().get_visible_rect().size
		var left_corner_rect = Rect2(0, 0, CORNER_SIZE, CORNER_SIZE)
		var right_corner_rect = Rect2(viewport_size.x - CORNER_SIZE, 0, CORNER_SIZE, CORNER_SIZE)
		if event.pressed:
			if left_corner_rect.has_point(touch_pos):
				is_touching_left = true
				touch_left_start_time = Time.get_ticks_msec() / 1000.0
				print("Touch in linker Ecke erkannt: ", touch_pos)
			elif right_corner_rect.has_point(touch_pos):
				is_touching_right = true
				touch_right_start_time = Time.get_ticks_msec() / 1000.0
				print("Touch in rechter Ecke erkannt: ", touch_pos)
		else:
			is_touching_left = false
			is_touching_right = false
			print("Touch beendet")

func _process(delta: float) -> void:
	# Touch-Logik für Mobile während der Pause
	if is_touching_left and is_touching_right and get_tree().paused:
		var current_time = Time.get_ticks_msec() / 1000.0
		if (current_time - touch_left_start_time >= TOUCH_HOLD_TIME and 
			current_time - touch_right_start_time >= TOUCH_HOLD_TIME):
			print("Touch für 3 Sekunden in beiden Ecken, öffne Debug-Menü")
			if debug_menu:
				debug_menu.visible = true
			is_touching_left = false
			is_touching_right = false

# Bestehende Funktionen
func _on_coin_collected(level_count: int, global_count: int):
	update_hud(level_count, global_count)

func _on_coin_count_updated(global_count: int):
	update_hud(Global.level_coin_count, global_count)

func update_hud(level_count: int, global_count: int):
	level_coin_label.text = ": %d/%d" % [level_count, Global.MAX_COINS_PER_LEVEL]
	global_coin_label.text = ": %d" % global_count
	print("HUD aktualisiert: Level Coins = %d/%d, Global Coins = %d" % [level_count, Global.MAX_COINS_PER_LEVEL, global_count])

# Pause-Menü Funktionen
func _on_pause_button_pressed():
	get_tree().paused = true
	pause_menu.visible = true
	print("Pause-Menü geöffnet, Spiel pausiert")

func _on_resume_button_pressed():
	get_tree().paused = false
	pause_menu.visible = false
	if debug_menu:
		debug_menu.visible = false
	print("Spiel fortgesetzt, Debug-Menü geschlossen")

func _on_restart_button_pressed():
	get_tree().paused = false
	if debug_menu:
		debug_menu.visible = false
	get_tree().reload_current_scene()
	print("Szene neu gestartet")

func _on_quit_button_pressed():
	get_tree().paused = false
	if debug_menu:
		debug_menu.visible = false
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
	print("Zum Hauptmenü gewechselt")

# Debug-Menü Funktionen
func _on_teleport_button_pressed() -> void:
	get_tree().paused = false
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var x = $DebugMenu/VBoxContainer/HBoxContainer/LineEditX.text.to_float()
		var y = $DebugMenu/VBoxContainer/HBoxContainer/LineEditY.text.to_float()
		player.global_position = Vector2(x, y)
		print("Teleportiert zu Position: ", Vector2(x, y))
	else:
		print("FEHLER: Kein Spieler in der Gruppe 'Player' gefunden!")
	get_tree().paused = true

func _on_exit_debug_pressed() -> void:
	if debug_menu:
		debug_menu.visible = false
	print("Debug-Menü geschlossen")

func _on_invincible_button_up() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.collision_layer = 1
		player.collision_mask = 1
		print("Spieler unbesiegbar")

func _on_invincible_button_down() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.collision_layer = 1
		player.collision_mask = 2
		print("Spieler nicht mehr unbesiegbar")

func _on_add_coins_pressed() -> void:
	ProgressManager.global_coin_count += 5
	Global.global_coin_count = ProgressManager.global_coin_count
	ProgressManager.save_progress()
	ProgressManager.emit_signal("coin_count_updated", ProgressManager.global_coin_count)
	print("5 Münzen hinzugefügt")

func _on_values_button_up() -> void:
	var fps = Engine.get_frames_per_second()
	var mem = Performance.get_monitor(Performance.MEMORY_STATIC) / (1024 * 1024)
	$LabelFPS.text = "FPS: %d | Memory: %.2f MB" % [fps, mem]
	$LabelFPS.show()
	print("FPS und Speicher angezeigt")

func _on_values_button_down() -> void:
	$LabelFPS.hide()
	print("FPS und Speicher ausgeblendet")

func _on_check_button_button_up() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.max_air_flings = 32000
		print("Max Air Flings auf 32000 gesetzt")

func _on_check_button_button_down() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.max_air_flings = 1
		print("Max Air Flings auf 1 gesetzt")

func _on_reset_button_pressed() -> void:
	ProgressManager.reset_progress()
	print("Fortschritt wurde zurückgesetzt!")

func _on_Coin_reset_button_pressed() -> void:
	Global.level_coin_count = 0
	ProgressManager.global_coin_count = 0
	Global.global_coin_count = 0
	Global.collected_coins = {}
	ProgressManager.collected_coins = {}
	ProgressManager.save_progress()
	ProgressManager.emit_signal("coin_count_updated", 0)
	print("Coins zurückgesetzt!")

func _on_level_unlock_button_pressed() -> void:
	ProgressManager.highest_completed_level = 48
	ProgressManager.unlocked_bonus_levels = [48, 49, 50, 51, 52, 53]
	ProgressManager.save_progress()
	print("Alle Levels freigeschaltet!")
