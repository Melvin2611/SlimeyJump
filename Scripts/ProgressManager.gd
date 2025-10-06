extends Node

# Signal, das ausgesendet wird, wenn sich global_coin_count ändert
signal coin_count_updated(new_count: int)
signal show_something

# Speichert das höchste freigeschaltete Level (0 = Level 1 freigeschaltet)
var highest_completed_level: int = 0

# Liste der freigeschalteten Bonuslevel
var unlocked_bonus_levels: Array[int] = []

# Coin-Daten (geteilt mit Global-Skript)
var global_coin_count: int = 0
var collected_coins: Dictionary = {}  # Speichert eingesammelte Münzen pro Level

# Liste der Level-Szenen (Pfad zu den Szenen)
var levels: Array[String] = [
	"res://Scenes/Levels/W1/Level 1/Level1.tscn",
	"res://Scenes/Levels/W1/Level 2/Level2.tscn",
	"res://Scenes/Levels/W1/Level 3/Level3.tscn",
	"res://Scenes/Levels/W1/Level 4/Level4.tscn",
	"res://Scenes/Levels/W1/Level 5/level5.tscn",
	"res://Scenes/Levels/W1/Level 6/Level6.tscn",
	"res://Scenes/Levels/W2/Level 7/Level7.tscn",
	"res://Scenes/Levels/W2/Level 8/level8.tscn",
	"res://Scenes/Levels/W2/Level 9/Level9.tscn",
	"res://Scenes/Levels/W2/Level 10/Level10.tscn",
	"res://Scenes/Levels/W2/Level 11/level11.tscn",
	"res://Scenes/Levels/W2/Level 12/Level12.tscn",
	"res://Scenes/Levels/W3/Level 13/level13.tscn",
	"res://Scenes/Levels/W3/Level 14/Level14.tscn",
	"res://Scenes/Levels/W3/Level 15/Level15.tscn",
	"res://Scenes/Levels/W3/Level 16/Level16.tscn",
	"res://Scenes/Levels/W3/Level 17/level17.tscn",
	"res://Scenes/Levels/W3/Level 18/Level18.tscn",
	"res://Scenes/Levels/W4/Level 19/Level19.tscn",
	"res://Scenes/Levels/W4/Level 20/Level20.tscn",
	"res://Scenes/Levels/W4/Level 21/Level21.tscn",
	"res://Scenes/Levels/W4/Level 22/Level22.tscn",
	"res://Scenes/Levels/W4/Level 23/Level23.tscn",
	"res://Scenes/Levels/W4/Level 24/Level24.tscn",
	"res://Scenes/Levels/W5/Level 25/Level25.tscn",
	"res://Scenes/Levels/W5/Level 26/Level26.tscn",
	"res://Scenes/Levels/W5/Level 27/Level27.tscn",
	"res://Scenes/Levels/W5/Level 28/Level28.tscn",
	"res://Scenes/Levels/W5/Level 29/Level29.tscn",
	"res://Scenes/Levels/W5/Level 30/Level30.tscn",
	"res://Scenes/Levels/W6/Level 31/Level31.tscn",
	"res://Scenes/Levels/W6/Level 32/Level32.tscn",
	"res://Scenes/Levels/W6/Level 33/Level33.tscn",
	"res://Scenes/Levels/W6/Level 34/Level34.tscn",
	"res://Scenes/Levels/W6/Level 35/Level35.tscn",
	"res://Scenes/Levels/W6/Level 36/Level36.tscn",
	"res://Scenes/Levels/W7/Level 37/Level37.tscn",
	"res://Scenes/Levels/W7/Level 38/Level38.tscn",
	"res://Scenes/Levels/W7/Level 39/Level39.tscn",
	"res://Scenes/Levels/W7/Level 40/Level40.tscn",
	"res://Scenes/Levels/W7/Level 41/Level41.tscn",
	"res://Scenes/Levels/W7/Level 42/Level42.tscn",
	"res://Scenes/Levels/W8/Level 43/Level43.tscn",
	"res://Scenes/Levels/W8/Level 44/Level44.tscn",
	"res://Scenes/Levels/W8/Level 45/Level45.tscn",
	"res://Scenes/Levels/W8/Level 46/Level46.tscn",
	"res://Scenes/Levels/W8/Level 47/Level47.tscn",
	"res://Scenes/Levels/W8/Level 48/Level48.tscn",
	"res://Scenes/Levels/Bonus/Level 49/Level49.tscn",
	"res://Scenes/Levels/Bonus/Level 50/Level50.tscn",
	"res://Scenes/Levels/Bonus/Level 51/Level51.tscn",
	"res://Scenes/Levels/Bonus/Level 52/Level52.tscn",
	"res://Scenes/Levels/Bonus/Level 53/Level53.tscn",
	"res://Scenes/Levels/Bonus/Level 54/Level54.tscn"
]

func _ready():
	load_progress()
	emit_signal("coin_count_updated", global_coin_count)  # Initiale Anzeige im HUD
	print("Spielstart: highest_completed_level = ", highest_completed_level, ", global_coin_count = ", global_coin_count, ", unlocked_bonus_levels = ", unlocked_bonus_levels)

# Funktion zum Aktualisieren des Fortschritts
func complete_level(level_index: int):
	if level_index >= highest_completed_level and level_index < 48: # Bonuslevel beeinflussen nicht highest_completed_level
		highest_completed_level = level_index + 1 # Erhöhe auf das nächste Level
		save_progress()
		print("Level abgeschlossen: ", level_index, ", highest_completed_level = ", highest_completed_level)

# Funktion zum Freischalten eines Bonuslevels
func unlock_bonus_level(level_index: int) -> bool:
	if level_index >= 48 and level_index < levels.size() and global_coin_count >= 24 and level_index not in unlocked_bonus_levels:
		global_coin_count -= 24
		emit_signal("coin_count_updated", global_coin_count)  # Signal für HUD vor dem Speichern
		unlocked_bonus_levels.append(level_index)
		save_progress()
		print("Bonuslevel ", level_index + 1, " freigeschaltet. Verbleibende Münzen: ", global_coin_count)
		return true
	return false

# Funktion zum Prüfen, ob ein Level freigeschaltet ist
func is_level_unlocked(level_index: int) -> bool:
	if level_index < 48: # Normale Level
		return level_index <= highest_completed_level
	else: # Bonuslevel
		return level_index in unlocked_bonus_levels

# Funktion zum Abrufen des nächsten Levels
func get_next_level() -> String:
	var next_level_index = highest_completed_level
	if next_level_index < 48: # Nur normale Level
		return levels[next_level_index]
	else:
		return levels[0] # Fallback: Zurück zum ersten Level

# Speichere Fortschritt in einer Datei (JSON für alle Daten)
func save_progress():
	# sichere Kopie mit ints, damit die gespeicherten Werte integer-ähnlich sind
	var bonus_levels_for_save: Array = []
	for b in unlocked_bonus_levels:
		bonus_levels_for_save.append(int(b))

	var save_data = {
		"highest_completed_level": int(highest_completed_level),
		"unlocked_bonus_levels": bonus_levels_for_save,
		"global_coin_count": int(global_coin_count),
		"collected_coins": collected_coins
	}

	var file = FileAccess.open("user://progress.save", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Level-Fortschritt gespeichert: ", save_data)
	else:
		print("Fehler: Konnte progress.save nicht speichern!")


func load_progress():
	if FileAccess.file_exists("user://progress.save"):
		var file = FileAccess.open("user://progress.save", FileAccess.READ)
		if file:
			var save_data = JSON.parse_string(file.get_as_text())
			file.close()
			if save_data is Dictionary:
				# highest / coins als ints lesen (falls JSON number als float kommt)
				highest_completed_level = int(save_data.get("highest_completed_level", 0))

				# Bonuslevel-Liste sauber rekonstruieren (akzeptiere float und int)
				unlocked_bonus_levels = []
				var loaded_bonus_levels = save_data.get("unlocked_bonus_levels", [])
				for item in loaded_bonus_levels:
					# JSON liefert häufig floats; akzeptiere beides und cast zu int
					if item is int or item is float:
						unlocked_bonus_levels.append(int(item))
					else:
						print("Warnung: Ungültiges Element in unlocked_bonus_levels: ", item)

				global_coin_count = int(save_data.get("global_coin_count", 0))
				if global_coin_count < 0:
					print("Warnung: global_coin_count ist negativ (", global_coin_count, "), setze auf 0")
					global_coin_count = 0

				collected_coins = save_data.get("collected_coins", {})
				emit_signal("coin_count_updated", global_coin_count)
				print("Level-Fortschritt geladen: ", save_data)
				print(" -> konvertierte unlocked_bonus_levels: ", unlocked_bonus_levels)
			else:
				print("Fehler: Ungültiges Dateiformat in progress.save")
	else:
		highest_completed_level = 0
		unlocked_bonus_levels = []
		global_coin_count = 0
		collected_coins = {}
		emit_signal("coin_count_updated", global_coin_count)
		print("Keine progress.save gefunden, starte bei Default-Werten")


# Funktion zum Zurücksetzen des Fortschritts
func reset_progress():
	highest_completed_level = 0
	unlocked_bonus_levels = []
	global_coin_count = 0
	collected_coins = {}
	if FileAccess.file_exists("user://progress.save"):
		var dir = DirAccess.open("user://")
		if dir:
			dir.remove("progress.save")
			print("Fortschrittsdatei gelöscht.")
		else:
			print("Fehler: Konnte Fortschrittsdatei nicht löschen!")
	save_progress()
	emit_signal("coin_count_updated", global_coin_count)  # Signal für HUD
	print("Fortschritt zurückgesetzt: highest_completed_level = ", highest_completed_level, ", global_coin_count = ", global_coin_count, ", unlocked_bonus_levels = ", unlocked_bonus_levels)
