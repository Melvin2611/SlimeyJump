extends Node

signal coin_collected(level_count: int, global_count: int)  # Signal mit Level- und globalem Münzstand

var level_coin_count: int = 0  # Münzen im aktuellen Level
var global_coin_count: int = 0  # Globaler Münzstand für Käufe (geteilt)
var collected_coins: Dictionary = {}  # Speichert eingesammelte Münzen pro Level (geteilt)
const MAX_COINS_PER_LEVEL: int = 3  # Maximale Münzen pro Level
var current_level: String = ""  # Name des aktuellen Levels

# Level-Daten (geteilt mit ProgressManager)
var highest_completed_level: int = 0  # Nicht verwendet hier, aber für Konsistenz

func _ready():
	# Lade gespeicherte Daten beim Spielstart (verwende die gleiche Load-Funktion)
	load_progress()

func set_current_level(level_name: String):
	# Setze den aktuellen Level-Namen und initialisiere Münzen für diesen Level
	current_level = level_name
	if not collected_coins.has(level_name):
		collected_coins[level_name] = []
	level_coin_count = collected_coins[level_name].size()  # Setze auf bereits gesammelte Anzahl (nicht zurücksetzen)
	save_progress()  # Speichere nach Level-Wechsel

func collect_coin(coin_id: String):
	if level_coin_count < MAX_COINS_PER_LEVEL and not coin_id in collected_coins.get(current_level, []):
		level_coin_count += 1
		global_coin_count += 1
		collected_coins[current_level].append(coin_id)  # Münze als gesammelt markieren
		coin_collected.emit(level_coin_count, global_coin_count)  # Signal senden
		save_progress()  # Speichere nach Münzsammeln

func is_coin_collected(level_name: String, coin_id: String) -> bool:
	# Prüft, ob eine Münze in einem Level bereits eingesammelt wurde
	return coin_id in collected_coins.get(level_name, [])

func reset_level_coins():
	# Setzt nur den Level-Münzstand zurück, nicht den globalen
	if collected_coins.has(current_level):
		global_coin_count -= collected_coins[current_level].size()  # Ziehe ab, falls Reset bedeutet, Coins zu entfernen
		collected_coins[current_level] = []
	level_coin_count = 0
	coin_collected.emit(level_coin_count, global_coin_count)
	save_progress()  # Speichere nach Reset

# Speichere Fortschritt in einer Datei (JSON für alle Daten) – identisch zum Level-Skript
func save_progress():
	var save_data = {
		"global_coin_count": global_coin_count,
		"collected_coins": collected_coins
	}
	var file = FileAccess.open("user://coins.save", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Coins gespeichert: ", save_data)
	else:
		print("Fehler: Konnte coins.save nicht speichern!")

func load_progress():
	if FileAccess.file_exists("user://coins.save"):
		var file = FileAccess.open("user://coins.save", FileAccess.READ)
		if file:
			var save_data = JSON.parse_string(file.get_as_text())
			file.close()
			if save_data is Dictionary:
				global_coin_count = save_data.get("global_coin_count", 0)
				collected_coins = save_data.get("collected_coins", {})
				print("Coins geladen: ", save_data)
			else:
				print("Fehler: Ungültiges Dateiformat in coins.save")
		else:
			print("Fehler beim Öffnen der coins.save zum Laden")
	else:
		global_coin_count = 0
		collected_coins = {}
		print("Keine coins.save gefunden, starte bei Default-Werten")
