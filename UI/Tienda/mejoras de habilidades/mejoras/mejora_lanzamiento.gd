extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	jugador.lanza_basura.distancia_vuelo += 50
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.lanza_basura.distancia_vuelo, jugador.lanza_basura.distancia_vuelo + 50)
