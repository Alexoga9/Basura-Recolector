# scripts/ItemPickup.gd
extends Area2D

@export var item_data: LootDefinicion # Qué tipo de objeto es este


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Inventario.add_item(item_data)
		queue_free() # desaparece del mundo
