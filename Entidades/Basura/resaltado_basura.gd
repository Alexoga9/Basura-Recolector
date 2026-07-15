extends ResaltadoComponente

@onready var basura: Basura = $".."


func _on_area_2d_mouse_entered():
	if basura.en_area_jugador:
		al_mouse_entrar()


func _on_area_2d_mouse_exited():
	al_mouse_salir()
