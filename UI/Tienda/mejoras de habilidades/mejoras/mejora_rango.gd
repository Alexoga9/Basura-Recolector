extends Logica_Mejora

@export_multiline var mensaje_notificacion: String


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_rango +=1
	setear_nivel()
	mejora_azada()
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.radar_componente.basura_collider.shape.radius, jugador.radar_componente.basura_collider.shape.radius + 10)


func setear_nivel():
	var nuevo_radio := 25.0 + (NivelesDeExperiencia.nivel_rango - 1) * 5.0
	jugador.estadisticas_componente.actualizar_herramientas()

	if jugador.radar_componente.basura_collider.shape.radius != nuevo_radio:
		jugador.radar_componente.basura_collider.shape.radius = nuevo_radio
		jugador.radar_componente.loot_collector_shape.shape.radius = nuevo_radio


func mejora_azada():
	if NivelesDeExperiencia.nivel_rango >= 3:
		print("AZADA")
		SignalBus.notificacion.emit(mensaje_notificacion)
