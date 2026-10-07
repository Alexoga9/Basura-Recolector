extends Logica_Mejora

@export var honguito: DataConsumible


func _ready():
	iniciar()


func aplicar_mejora():
	honguito.recuperar_energia += 2
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(honguito.recuperar_energia, honguito.recuperar_energia + 2)
