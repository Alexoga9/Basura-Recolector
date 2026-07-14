extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	jugador.lanza_basura.distancia_vuelo += 50
