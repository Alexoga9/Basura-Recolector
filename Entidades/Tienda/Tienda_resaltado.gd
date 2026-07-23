extends ResaltadoComponente


#func _ready():
	#no_resaltado()
	#ocutlar_e()


func resaltado():
	outline_on()
	mostrar_e()


func no_resaltado():
	outline_off()
	ocutlar_e()


func _on_trigger_jugador_body_entered(body):
	resaltado()


func _on_trigger_jugador_body_exited(body):
	no_resaltado()
