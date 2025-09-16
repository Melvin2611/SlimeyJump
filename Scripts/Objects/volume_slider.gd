extends HSlider

# Angenommen, du steuerst den Master-Bus
var bus_name = "Master"
var bus_index = AudioServer.get_bus_index(bus_name)

func _ready():
	value = 50 

func _on_value_changed(value: float):
	var db = linear_to_db(value) 
	AudioServer.set_bus_volume_db(bus_index, db)
