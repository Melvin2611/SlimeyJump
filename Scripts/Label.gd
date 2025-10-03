extends Label

@export var text_key: String

func _ready():
	update_text()

func update_text():
	text = Localization.get_text(text_key)
