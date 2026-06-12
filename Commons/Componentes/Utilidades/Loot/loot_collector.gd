@icon("res://addons/iconos/PickUp.svg")
extends Area2D

@onready var energia_componente = %EnergiaComponente

# Hacer un ajuste en cuanto a la energia componente apartir de vida
func _on_area_entered(area):
	if area.is_in_group("Loot"):
		match area.tipo_de_loot:

			#area.data.TipoLoot.VIDA:
				##print("Vida")
				#vida_componente.curar(area.valor)

			area.data.TipoLoot.DINERO:
				#print("Dinero")
				pass

			area.data.TipoLoot.POWER_UP:
				#print("Power Up")
				pass
