# scripts/InventorySlot.gd
extends Panel

@export var item_data: LootDefinicion # Arrastra el .tres aquí en el inspector

@onready var count_label = %Label
@onready var icon = %Icono
@onready var label_2: Label = %Label2


func _ready():
	if item_data.sprite:
		icon.texture = item_data.sprite

	_update_display(item_data.id,Inventario.get_count(item_data.id))

	# Escucha cambios del singleton
	Inventario.slot_updated.connect(_on_slot_updated)


func _on_slot_updated(item_id: String, new_count: int):
	_update_display(item_id, new_count)


func _update_display(item_id: String, count: int):
	if item_id == "piedra":
		count_label.text = str(count) if count > 0 else ""

	if item_id == "madera":
		label_2.text = str(count) if count > 0 else ""
