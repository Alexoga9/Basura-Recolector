extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	jugador.recoge_basura.basura_collider.shape.radius += 10
