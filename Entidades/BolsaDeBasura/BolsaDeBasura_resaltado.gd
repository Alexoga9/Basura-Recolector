extends ResaltadoComponente


func _ready():

	# Ahora conectamos correctamente
	trigger_area.body_entered.connect(_on_trigger_jugador_body_entered)
	trigger_area.body_exited.connect(_on_trigger_jugador_body_exited)


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		resaltado()


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		no_resaltado()
