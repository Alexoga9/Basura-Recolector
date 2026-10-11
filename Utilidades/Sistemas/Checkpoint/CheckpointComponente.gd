class_name CheckpointComponente extends Node2D

@export var entrada: int
@onready var jugador: Jugador = get_tree().get_first_node_in_group("Jugador")
var padre: CheckpointManager


func _ready():
	padre = get_parent()
	comparar_entradas()


func comparar_entradas():
	if padre.saldra_por == entrada:
		jugador.global_position = global_position
