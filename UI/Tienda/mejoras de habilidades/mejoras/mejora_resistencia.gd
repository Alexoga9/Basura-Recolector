extends Logica_Mejora

@export_multiline var mensaje_notificacion: String


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_resistencia += 1
	setear_nivel()
	mejora_pico()
	actualizar_datos()


func setear_nivel():
	var nueva_energia_maxima := 10 + (NivelesDeExperiencia.nivel_resistencia - 1) * 2
	jugador.energia_componente.energia_maxima = nueva_energia_maxima
	jugador.estadisticas_componente.actualizar_herramientas()


func actualizar_datos():
	panel.estadisticas(jugador.energia_componente.energia_maxima, jugador.energia_componente.energia_maxima + 10)


func mejora_pico():
	if NivelesDeExperiencia.nivel_resistencia >= 3:
		print("PICO")
		SignalBus.notificacion.emit(mensaje_notificacion)
