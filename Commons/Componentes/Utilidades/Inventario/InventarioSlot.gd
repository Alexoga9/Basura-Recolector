# scripts/InventorySlot.gd
extends Panel


func _ready():
#	_update_display(item_data.id,Inventario.get_count("item_data.id"))

	Inventario.slot_updated.connect(_on_slot_updated)


func _on_slot_updated(item_id: String, new_count: int):
	_update_display(item_id, new_count)


func _update_display(item_id: String, count: int):
	pass
