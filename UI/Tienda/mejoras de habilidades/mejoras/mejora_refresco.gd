extends Logica_Mejora

@export var honguito: DataConsumible


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_refrescos +=1
	setear_nivel()
	actualizar_datos()


func setear_nivel():
	var nueva_recuperacion_energia := NivelesDeExperiencia.nivel_refrescos * 10
	nueva_recuperacion_energia = jugador.beber_refresco.energia_recuperada


func actualizar_datos():
	panel.estadisticas(honguito.recuperar_energia, honguito.recuperar_energia + 2)
