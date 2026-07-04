extends Node

#@onready var jugador: Jugador = get_tree().get_first_node_in_group("Jugador")

var jugador: Jugador = null


func set_jugador(jugador_ref: Jugador):
	jugador = jugador_ref
	print("✅ Jugador asignado en Global: ", jugador.name)
