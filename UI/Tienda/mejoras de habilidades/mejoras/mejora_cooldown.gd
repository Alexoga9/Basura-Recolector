extends Logica_Mejora


# Called when the node enters the scene tree for the first time.
func _ready():
	iniciar()


func aplicar_mejora():
	jugador.recoge_basura.cooldown_tiempo -= 0.2
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(jugador.recoge_basura.cooldown_tiempo, jugador.recoge_basura.cooldown_tiempo - 0.2)
