# scripts/InventorySlot.gd
extends Panel

@export var item_data: LootDefinicion # Arrastra el .tres aquí en el inspector

@onready var count_label = %Label
@onready var icon = %TextureRect


func _ready() -> void:
	if item_data:
		icon.texture = item_data.sprite

	_update_display(Inventario.get_count(item_data.id))

	# Escucha cambios del singleton
	Inventario.slot_updated.connect(_on_slot_updated)


func _on_slot_updated(item_id: String, new_count: int) -> void:
	if item_id == item_data.id:
		_update_display(new_count)


func _update_display(count: int) -> void:
	count_label.text = str(count) if count > 0 else ""
	icon.modulate.a = 1.0 if count > 0 else 0.3 # dime si está vacío
