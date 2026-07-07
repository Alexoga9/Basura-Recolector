class_name Logica_Mejora extends Node

var jugador: Jugador


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func iniciar():
	await get_tree().process_frame
	jugador = Global.jugador
	#print("Esta el " + jugador.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func aplicar_mejora():
	pass
