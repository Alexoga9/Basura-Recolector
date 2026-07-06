@icon("res://addons/iconos/PickUp.svg")
extends Area2D

@onready var energia_componente = %EnergiaComponente
@onready var input_componente = %InputComponente


# Hacer un ajuste en cuanto a la energia componente apartir de vida
func _on_area_entered(object: Loot):
	if object.is_in_group("Loot"):
		match object.tipo_de_basura:

			Loot.TipoBasura.BASICO:
				Inventario.add_item(object.data)
				object.collect()
				pass

			object.TipoLoot.PESADO:
				Inventario.add_item(object.data)
				pass

			#object.TipoLoot.PAQUETE:
				#print("Loot Paquete")
				#Inventario.add_item(object.data)
				#pass
