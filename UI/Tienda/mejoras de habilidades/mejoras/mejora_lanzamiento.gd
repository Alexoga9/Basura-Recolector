extends Logica_Mejora


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_lanzamiento +=1
	setear_nivel()
	actualizar_datos()


func setear_nivel():
	var nuevo_fuerza_lanzamiento := 100.0 + (NivelesDeExperiencia.nivel_lanzamiento - 1) * 10.0
	var nuevo_distancia_vuelo := 50.0 + (NivelesDeExperiencia.nivel_lanzamiento - 1) * 10.0

	if jugador.lanza_basura.fuerza_lanzamiento != nuevo_fuerza_lanzamiento:
		jugador.lanza_basura.fuerza_lanzamiento = nuevo_fuerza_lanzamiento
		jugador.lanza_basura.distancia_vuelo = nuevo_distancia_vuelo


func actualizar_datos():
	panel.estadisticas(jugador.lanza_basura.distancia_vuelo, jugador.lanza_basura.distancia_vuelo + 50)
