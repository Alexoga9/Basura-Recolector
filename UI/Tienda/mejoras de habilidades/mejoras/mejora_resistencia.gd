extends Logica_Mejora

@export_multiline var mensaje_notificacion: String


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
		SignalBus.notificacion.emit(mensaje_notificacion)
