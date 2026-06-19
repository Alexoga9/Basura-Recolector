extends Control

signal slot_updated(item_id: String, new_count: int)

var _counts: Dictionary = {}


func add_item(item: LootDefinicion) -> void:
	if _counts.get(item.id, 0) >= item.valor:
		print("[Inventory] Slot lleno: ", item.id)
		return

	_counts[item.id] = _counts.get(item.id, 0) + 1
	slot_updated.emit(item.id, _counts[item.id])


func get_count(item_id: String) -> int:
	return _counts.get(item_id, 0)


func has_item(item_id: String, amount: int = 1) -> bool:
	return get_count(item_id) >= amount


func remove_item(item_id: String, amount: int = 1) -> bool:

	if not has_item(item_id, amount):
		return false

	_counts[item_id] -= amount
	slot_updated.emit(item_id, _counts[item_id])
	return true
