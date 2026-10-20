extends Logica_Mejora

@export var data_basura: LootDefinicion


func _ready():
	iniciar()


func aplicar_mejora():
	NivelesDeExperiencia.nivel_peso +=1
	setear_nivel()
	actualizar_datos()


func setear_nivel():
	var nuevo_peso := 3 + (NivelesDeExperiencia.nivel_peso - 1) * 2

	if Inventario.peso_maximo != nuevo_peso:
		Inventario.peso_maximo = nuevo_peso


func actualizar_datos():
	panel.estadisticas(Inventario.peso_maximo, Inventario.peso_maximo + 2)
