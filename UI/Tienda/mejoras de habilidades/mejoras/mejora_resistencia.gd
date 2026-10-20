extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_resistencia += 1
	jugador.energia_componente.aumentar_energia_maxima(10)
	mejora_pico()
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.energia_componente.energia_maxima, jugador.energia_componente.energia_maxima + 10)


func mejora_pico():
	if NivelesDeExperiencia.nivel_resistencia >= 3:
		print("PICO")
		jugador.estadisticas_componente.pico += 1
