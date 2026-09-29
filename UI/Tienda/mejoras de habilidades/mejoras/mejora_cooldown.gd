extends Logica_Mejora


# Called when the node enters the scene tree for the first time.
func _ready():
	iniciar()


func aplicar_mejora():
	jugador.radar_componente.cooldown_tiempo -= 0.2
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.radar_componente.cooldown_tiempo, jugador.radar_componente.cooldown_tiempo - 0.2)
