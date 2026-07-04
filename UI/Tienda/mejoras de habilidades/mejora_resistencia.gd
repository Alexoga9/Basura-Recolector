extends Logica_Mejora


func _ready():
	iniciar()
	print(jugador)


func aplicar_mejora():
	print(str(jugador.energia_componente.energia_maxima))
	jugador.energia_componente.aumentar_energia_maxima(10)
	print(str(jugador.energia_componente.energia_maxima))
