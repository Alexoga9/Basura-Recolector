class_name SlotDeInventario extends HBoxContainer

@export var id_a_recibir: String
@onready var icono = %Icono
@onready var label = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Inventario.slot_updated.connect(actualizar_slot)

	# El Inventario es un autoload y sobrevive al cambio de escena, pero este
	# slot se crea de nuevo con la escena: hay que leer el estado actual.
	# Si hay 0, actualizar_slot lo deja escondido.
	actualizar_slot(id_a_recibir, Inventario.get_count(id_a_recibir))


func actualizar_slot(item_id: String, cantidad: int):
	# Filtramos inmediatamente si la señal no es para este slot.
	if item_id != id_a_recibir:
		return

	# Si la cantidad es 0 o menor
	if cantidad <= 0:
		hide()
		label.text = str(0)
		label.modulate = Color.WHITE
		return

	# Obtenemos el recurso y actualizamos la UI
	var item = Inventario.get_item_resource(item_id)

	if item != null:
		show()
		icono.texture = item.sprite
		label.text = str(cantidad)

		if item.cantidad_maxima == cantidad:
			label.modulate = Color.RED
		else:
			label.modulate = Color.WHITE
