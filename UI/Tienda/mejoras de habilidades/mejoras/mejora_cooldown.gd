extends Logica_Mejora


# Called when the node enters the scene tree for the first time.
func _ready():
	iniciar()


func aplicar_mejora():
	jugador.recoge_basura.cooldown_tiempo -= 2
