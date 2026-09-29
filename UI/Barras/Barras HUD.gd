extends Node

@onready var barra_energia = %BarraEnergia
@onready var barra_basura = %BarraBasura

var jugador: Jugador


func _ready():
	await get_tree().process_frame
	jugador = Global.jugador
	jugador.energia_componente.valor_energia_cambiado.connect(igualar_barra_energia)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	igualar_barra_energia(null)
	igualar_barra_basura()


func igualar_barra_energia(_energia):
	barra_energia.valor_max = jugador.energia_componente.energia_maxima
	barra_energia.valor_actual = jugador.energia_componente.energia
	#await get_tree().create_timer(1.5).timeout
	barra_energia.datos_barra_secundaria()


func igualar_barra_basura():
	var cantidad_basura: int = Inventario.peso
	var recurso_basura = Inventario.get_item_resource("Basura")

	barra_basura.valor_max = Inventario.peso_maximo
	barra_basura.valor_actual = Inventario.peso

	if Inventario.peso == 0:
		barra_basura.valor_actual = 0
