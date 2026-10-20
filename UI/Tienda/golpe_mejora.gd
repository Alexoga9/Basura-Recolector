extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_golpe +=1
	setear_nivel()
	actualizar_datos()


func setear_nivel():
	var nuevo_golpe := 1 + (NivelesDeExperiencia.nivel_cooldown - 1) * 2
	jugador.estadisticas_componente.golpe += nuevo_golpe


func actualizar_datos():
	panel.estadisticas(jugador.estadisticas_componente.golpe, jugador.estadisticas_componente.golpe + 1)
