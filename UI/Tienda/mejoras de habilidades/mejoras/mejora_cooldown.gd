extends Logica_Mejora

@export_multiline var mensaje_notificacion: String


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_cooldown += 1
	setear_nivel()
	mejora_hacha()
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.radar_componente.cooldown_tiempo, jugador.radar_componente.cooldown_tiempo - 0.2)


func setear_nivel():
	var nuevo_cooldown := 1.5 - (NivelesDeExperiencia.nivel_cooldown - 1) * 0.2
	nuevo_cooldown = max(nuevo_cooldown, 0.3) # mínimo 0.3s
	jugador.radar_componente.cooldown_tiempo = nuevo_cooldown
	#jugador.radar_componente.timer.wait_time = nuevo_cooldown


func mejora_hacha():
	if NivelesDeExperiencia.nivel_cooldown >= 3:
		print("HACHA")
		jugador.estadisticas_componente.hacha += 1
		SignalBus.notificacion.emit(mensaje_notificacion)
