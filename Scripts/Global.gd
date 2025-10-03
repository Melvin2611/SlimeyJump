extends Node

signal coin_collected(level_count: int, global_count: int)  # Signal mit Level- und globalem Münzstand

var level_coin_count: int = 0  # Münzen im aktuellen Level
var global_coin_count: int = 0  # Globaler Münzstand für Käufe (geteilt)
var collected_coins: Dictionary = {}  # Speichert eingesammelte Münzen pro Level (geteilt)
const MAX_COINS_PER_LEVEL: int = 3  # Maximale Münzen pro Level
var current_level: String = ""  # Name des aktuellen Levels

func _ready():
	# Lade gespeicherte Daten beim Spielstart (verwende die gleiche Load-Funktion aus ProgressManager)
	ProgressManager.load_progress()
	global_coin_count = ProgressManager.global_coin_count
	collected_coins = ProgressManager.collected_coins
	print("Global gestartet: global_coin_count = ", global_coin_count, ", collected_coins = ", collected_coins)

func set_current_level(level_name: String):
	# Setze den aktuellen Level-Namen und initialisiere Münzen für diesen Level
	current_level = level_name
	if not collected_coins.has(level_name):
		collected_coins[level_name] = []
	level_coin_count = collected_coins[level_name].size()  # Setze auf bereits gesammelte Anzahl
	ProgressManager.collected_coins = collected_coins
	ProgressManager.save_progress()  # Speichere nach Level-Wechsel

func collect_coin(coin_id: String):
	if level_coin_count < MAX_COINS_PER_LEVEL and not coin_id in collected_coins.get(current_level, []):
		level_coin_count += 1
		global_coin_count += 1
		ProgressManager.global_coin_count = global_coin_count
		collected_coins[current_level].append(coin_id)  # Münze als gesammelt markieren
		ProgressManager.collected_coins = collected_coins
		coin_collected.emit(level_coin_count, global_coin_count)  # Signal senden
		ProgressManager.save_progress()  # Speichere nach Münzsammeln
		ProgressManager.emit_signal("coin_count_updated", global_coin_count)  # Signal für HUD

func is_coin_collected(level_name: String, coin_id: String) -> bool:
	# Prüft, ob eine Münze in einem Level bereits eingesammelt wurde
	return coin_id in collected_coins.get(level_name, [])

func reset_level_coins():
	# Setzt nur den Level-Münzstand zurück
	if collected_coins.has(current_level):
		global_coin_count -= collected_coins[current_level].size()
		ProgressManager.global_coin_count = global_coin_count
		collected_coins[current_level] = []
		ProgressManager.collected_coins = collected_coins
	level_coin_count = 0
	coin_collected.emit(level_coin_count, global_coin_count)
	ProgressManager.save_progress()  # Speichere nach Reset
	ProgressManager.emit_signal("coin_count_updated", global_coin_count)  # Signal für HUD
