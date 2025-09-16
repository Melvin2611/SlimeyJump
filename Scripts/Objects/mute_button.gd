extends CheckButton

var bus_name = "Master"
var bus_index = AudioServer.get_bus_index(bus_name)

func _ready():
	button_pressed = false 

func _on_toggled(button_pressed: bool):
	AudioServer.set_bus_mute(bus_index, button_pressed)
