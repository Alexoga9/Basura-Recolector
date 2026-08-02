extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	jugador.estadisticas_componente.fuerza += 1
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.estadisticas_componente.fuerza, jugador.estadisticas_componente.fuerza + 1)
