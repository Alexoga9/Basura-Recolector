extends ResaltadoComponente


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		resaltado()


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		no_resaltado()
