class_name SlotDeInventario extends HBoxContainer

@export var id_a_recibir: String
@onready var icono = %Icono
@onready var label = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Inventario.slot_updated.connect(actualizar_slot)


func actualizar_slot(item_id: String, cantidad: int):
	var item = Inventario.get_item_resource(item_id)

	if item != null:
		if item_id == id_a_recibir:
			show()
			icono.texture = item.sprite
			label.text = str(cantidad)

		if item.cantidad_maxima == cantidad:
			label.modulate = Color.RED
		else:
			label.modulate = Color.WHITE
	else:
		label.text = str(0)
		label.modulate = Color.WHITE
