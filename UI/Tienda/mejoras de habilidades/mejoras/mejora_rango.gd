extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_rango +=1
	jugador.radar_componente.basura_collider.shape.radius += 10
	mejora_azada()
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.radar_componente.basura_collider.shape.radius, jugador.radar_componente.basura_collider.shape.radius + 10)


func mejora_azada():
	if NivelesDeExperiencia.nivel_rango >= 3:
		print("AZADA")
		jugador.estadisticas_componente.azada += 1
