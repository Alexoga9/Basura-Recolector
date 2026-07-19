extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	jugador.recoge_basura.basura_collider.shape.radius += 10
	actualizar_datos()

func actualizar_datos():
	panel.estadisticas(jugador.recoge_basura.basura_collider.shape.radius, jugador.recoge_basura.basura_collider.shape.radius + 10)
