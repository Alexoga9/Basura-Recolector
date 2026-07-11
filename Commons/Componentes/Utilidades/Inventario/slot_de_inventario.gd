class_name SlotDeInventario extends HBoxContainer

@export var id_a_recibir: String
@onready var icono = %Icono
@onready var label = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Inventario.slot_updated.connect(actualizar_slot)


func actualizar_slot(item_id: String, cantidad: int):
	if item_id == id_a_recibir:
		show()
		icono.texture = Inventario.get_item_resource(item_id).sprite
		label.text = str(cantidad)
