extends ResaltadoComponente


func _on_trigger_jugador_body_entered(body):
	resaltado()


func _on_trigger_jugador_body_exited(body):
	no_resaltado()
