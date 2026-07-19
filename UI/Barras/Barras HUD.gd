extends Node

@onready var barra_energia = %BarraEnergia
@onready var barra_basura = %BarraBasura

var jugador: Jugador


func _ready():
	await get_tree().process_frame
	jugador = Global.jugador


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	igualar_barra_energia()
	igualar_barra_basura()


func igualar_barra_energia():
	barra_energia.valor_max = jugador.energia_componente.energia_maxima
	barra_energia.valor_actual = jugador.energia_componente.energia


func igualar_barra_basura():
	if Inventario.get_count("Basura") == null or Inventario.get_count("Basura") <= 0:
		return

	var cantidad_basura: int = Inventario.get_count("Basura")
	var recurso_basura = Inventario.get_item_resource("Basura")

	if recurso_basura == null:
		barra_basura.valor_actual = 0

	barra_basura.valor_max = recurso_basura.cantidad_maxima
	barra_basura.valor_actual = cantidad_basura
