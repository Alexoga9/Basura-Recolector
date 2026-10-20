extends Logica_Mejora

@export_multiline var mensaje_notificacion: String


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_cooldown += 1
	jugador.radar_componente.cooldown_tiempo -= 0.2
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.radar_componente.cooldown_tiempo, jugador.radar_componente.cooldown_tiempo - 0.2)


func mejora_pico():
	if NivelesDeExperiencia.nivel_cooldown >= 3:
		print("HACHA")
		jugador.estadisticas_componente.hacha += 1
		SignalBus.notificacion.emit(mensaje_notificacion)
