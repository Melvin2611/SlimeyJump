extends PanelContainer

signal confirmed
signal cancelled

func _ready():
	# Verbinde die Button-Signale
	$VBoxContainer/ConfirmButton.pressed.connect(_on_confirm_button_pressed)
	$VBoxContainer/CancelButton.pressed.connect(_on_cancel_button_pressed)
	# Popup initial unsichtbar machen
	hide()

func _on_confirm_button_pressed():
	emit_signal("confirmed")
	hide() # oder queue_free(), wenn das Popup nur einmal gebraucht wird

func _on_cancel_button_pressed():
	emit_signal("cancelled")
	hide() # oder queue_free()
