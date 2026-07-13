extends HSlider

@export var bus_name: String
var bus_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(cambiar_valor)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)

	)


func cambiar_valor(valor:float):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(valor)

	)
