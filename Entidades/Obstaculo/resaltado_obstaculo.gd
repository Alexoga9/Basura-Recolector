extends ResaltadoComponente

@onready var obstaculo: Obstaculo = $".."


func _on_area_2d_mouse_entered():
	print("MOUSE")
	if obstaculo.en_area_jugador:
		resaltado()


func _on_area_2d_mouse_exited():
	no_resaltado()
