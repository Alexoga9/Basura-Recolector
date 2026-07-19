extends ResaltadoComponente

@onready var basura: Basura = $".."


func _on_area_2d_mouse_entered():
	if basura.en_area_jugador:
		resaltado()


func _on_area_2d_mouse_exited():
	no_resaltado()
