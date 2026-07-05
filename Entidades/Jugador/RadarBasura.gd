class_name RadarComponenteBasura extends Area2D

var cuerpos: Array[Basura]
@onready var jugador: Jugador = $".."


func _process(delta):
	recoger_basura()


func _on_body_entered(body):
	print("Basura aqui")
	if body.is_in_group("Basura"):
		cuerpos.append(body)
		print(cuerpos)


func _on_body_exited(body):
	if body.is_in_group("Basura"):
		cuerpos.erase(body)
		print(cuerpos)


func get_entidad_aleatoria() -> Basura:
	if cuerpos.is_empty():
		return null

	var indice = randi() % cuerpos.size() # usa % para conseguir un numero valido 
	return cuerpos[indice]


func recoger_basura():
	if Input.is_action_just_pressed("Interaccion"):

		if get_entidad_aleatoria() != null and jugador.energia_componente.energia > 0:
			get_entidad_aleatoria().collect()
			jugador.energia_componente.agotar(1)
