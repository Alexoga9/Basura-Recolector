extends Node


#@onready var jugador: Jugador = get_tree().get_first_node_in_group("Jugador")
func _ready():
	iniciar_pantalla()

var jugador: Jugador = null
var entrada_puerta: int


func set_jugador(jugador_ref: Jugador):
	jugador = jugador_ref
	print("✅ Jugador asignado en Global: ", jugador.name)


func iniciar_pantalla():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
