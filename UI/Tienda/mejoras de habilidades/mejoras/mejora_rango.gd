extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_rango +=1
	jugador.radar_componente.basura_collider.shape.radius += 10
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.radar_componente.basura_collider.shape.radius, jugador.radar_componente.basura_collider.shape.radius + 10)
