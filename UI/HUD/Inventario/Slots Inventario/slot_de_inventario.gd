class_name SlotDeInventario extends HBoxContainer

@export var id_a_recibir: String
@onready var icono = %Icono
@onready var label = %Label
@onready var label_con_sombreado: LabelSombreado = %"Label Con Sombreado"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Inventario.slot_updated.connect(actualizar_slot)


func actualizar_slot(item_id: String, cantidad: int):
	# Filtramos inmediatamente si la señal no es para este slot.
	if item_id != id_a_recibir:
		return

	# Si la cantidad es 0 o menor
	if cantidad <= 0:
		hide()
		label.text = str(0)
		label.modulate = Color.WHITE
		label_con_sombreado.actualizar_labels(0)
		return

	# Obtenemos el recurso y actualizamos la UI
	var item = Inventario.get_item_resource(item_id)

	if item != null:
		show()
		icono.texture = item.sprite
		label.text = str(cantidad)
		label_con_sombreado.actualizar_labels(cantidad)

		if item.cantidad_maxima == cantidad:
			label.modulate = Color.RED
		else:
			label.modulate = Color.WHITE
