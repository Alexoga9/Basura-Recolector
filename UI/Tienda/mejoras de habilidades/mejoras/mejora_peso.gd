extends Logica_Mejora

@export var data_basura: LootDefinicion


func _ready():
	iniciar()


func aplicar_mejora():
	Inventario.peso += 2
	actualizar_datos()


func actualizar_datos():
	panel.estadisticas(Inventario.peso, Inventario.peso + 2)
