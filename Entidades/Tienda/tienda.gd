extends StaticBody2D


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		pass # aqui se mostrara el menu de la tienda


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		pass # aqui se cerrara el menu de la tienda
