@icon("res://addons/iconos/PickUp.svg")
extends Area2D

@onready var vida_componente = %VidaComponente
@onready var experiencia_componente = %ExperienciaComponente


func _on_area_entered(area):
	if area.is_in_group("Loot"):
		match area.tipo_de_loot:
			area.data.TipoLoot.EXPERIENCIA:
				#print("Experiencia")
				#print(area.valor)
				experiencia_componente.calcular_xp(area.valor)
				area.collect()

			area.data.TipoLoot.VIDA:
				#print("Vida")
				vida_componente.curar(area.valor)

			area.data.TipoLoot.DINERO:
				#print("Dinero")
				pass

			area.data.TipoLoot.POWER_UP:
				#print("Power Up")
				pass
