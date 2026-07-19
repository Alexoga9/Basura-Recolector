extends Logica_Mejora

@export var data_basura: LootDefinicion


func _ready():
	iniciar()


func aplicar_mejora():
	data_basura.cantidad_maxima += 2
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(data_basura.cantidad_maxima, data_basura.cantidad_maxima + 2)
