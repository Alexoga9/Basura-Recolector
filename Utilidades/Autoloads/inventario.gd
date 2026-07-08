extends Control

signal slot_updated(item_id: String, new_count: int)

@export var items: Array[LootDefinicion]

var backpack: Dictionary = {}


func add_item(item: LootDefinicion, amount: int = 1) -> void:

	if not backpack.has(item.id):
		backpack[item.id] = [0, item]

	var cantidad_actual: int = backpack[item.id][0]

	if cantidad_actual + amount > item.cantidad_maxima:
		print("[Inventory] Slot lleno o capacidad excedida para: ", item.id)
		return

	backpack[item.id][0] += amount

	slot_updated.emit(item.id, backpack[item.id][0])
	print("[Inventory] Se añadió material. Estado de ", item.id, ": ", backpack[item.id][0])


func remove_item(item, amount: int = 1) -> bool:

	var item_id: String = item.id if item is LootDefinicion else item

	if not has_item(item_id, amount):
		print("[Inventory] No tienes suficientes ítems para remover: ", item_id)
		return false

	backpack[item_id][0] -= amount
	var cantidad_restante: int = backpack[item_id][0]

	if cantidad_restante <= 0:
		backpack.erase(item_id)
		cantidad_restante = 0

	slot_updated.emit(item_id, cantidad_restante)
	return true


func get_count(item_id: String) -> int:
	if backpack.has(item_id):
		return backpack[item_id][0]

	return 0


func has_item(item_id: String, amount: int = 1) -> bool:
	return get_count(item_id) >= amount


func get_item_resource(item_id: String) -> LootDefinicion:
	if backpack.has(item_id):
		return backpack[item_id][1]

	return null
