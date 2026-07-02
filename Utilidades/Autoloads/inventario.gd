extends Control

signal slot_updated(item_id: String, new_count: int, total_wallet_value: int)

var valor_total_acumulado: int = 0
var _counts: Dictionary = {}


func add_item(item: LootDefinicion) -> void:
	if _counts.get(item.id, 0) >= item.cantidad_maxima:
		print("[Inventory] Slot lleno para: ", item.id)
		return

	_counts[item.id] = _counts.get(item.id, 0) + 1
	valor_total_acumulado += item.valor

	slot_updated.emit(item.id, _counts[item.id], valor_total_acumulado)
	print("[Inventory] Ítems: ", _counts, " | Billetera Total: $", valor_total_acumulado)


func remove_item(item, amount: int = 1) -> bool:

	var item_id: String = item.id if item is LootDefinicion else item

	if not has_item(item_id, amount):
		print("[Inventory] No tienes suficientes ítems para remover: ", item_id)
		return false

	_counts[item_id] -= amount

	if item is LootDefinicion:
		valor_total_acumulado -= (item.valor * amount)

	if _counts[item_id] <= 0:
		_counts.erase(item_id)

	var nueva_cantidad = _counts.get(item_id, 0)
	slot_updated.emit(item_id, nueva_cantidad, valor_total_acumulado)

	print("[Inventory] Ítems: ", _counts, " | Billetera Total: $", valor_total_acumulado)
	return true


func get_total_wallet_value() -> int:
	return valor_total_acumulado


func modify_wallet_value(amount: int) -> void:
	valor_total_acumulado += amount

	if valor_total_acumulado < 0:
		valor_total_acumulado = 0

	slot_updated.emit("", 0, valor_total_acumulado)
	print("[Inventory] Billetera modificada manualmente. Nuevo Total: $", valor_total_acumulado)


func get_count(item_id: String) -> int:
	return _counts.get(item_id, 0)


func has_item(item_id: String, amount: int = 1) -> bool:
	return get_count(item_id) >= amount
