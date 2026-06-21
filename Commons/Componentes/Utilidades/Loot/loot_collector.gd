@icon("res://addons/iconos/PickUp.svg")
extends Area2D

@onready var energia_componente = %EnergiaComponente
var object: LootDefinicion


# Hacer un ajuste en cuanto a la energia componente apartir de vida
func _on_area_entered(objeto):
	if objeto.is_in_group("Loot"):
		match objeto.tipo_de_loot:

			object.TipoLoot.BASICO:
				print("Loot Basico")
				Inventario.add_item(object)
				pass

			object.TipoLoot.PESADO:
				print("Loot Pesodo")
				Inventario.add_item(object)
				pass

			object.TipoLoot.PAQUETE:
				print("Loot Paquete")
				Inventario.add_item(object)
				pass
