extends Node

var dialogues = {}
var current_language := "en"

func _ready():
	load_dialogues()

func load_dialogues():
	var file := FileAccess.open("res://Miscealanous/Language.json", FileAccess.READ)
	if file:
		var text := file.get_as_text()
		dialogues = JSON.parse_string(text)

func set_language(lang: String):
	if lang in dialogues:
		current_language = lang

func get_text(key: String) -> String:
	if dialogues.has(current_language) and dialogues[current_language].has(key):
		return dialogues[current_language][key]
	return "[MISSING: %s]" % key
