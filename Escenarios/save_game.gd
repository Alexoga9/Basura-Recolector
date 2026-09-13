extends Node
@export var player: Node2D
var jugador:Jugador
#var spawer: spawner
var Porcentaje_Limpieza: int


func _ready() -> void:
	jugador = Global.jugador


func Save_Game() -> void:
	var data = SaveData.new()
	#var Spawner = spawner.new()

	data.GuadarDinero = Dinero.dinero
	data.playerPosition = player.global_position
	data.Plimpieza = Porcentaje_Limpieza
	data.GuardadoInventario = Inventario.get_backpack_data()
	data.Penergia = jugador.energia_componente.energia
	data.Plimpieza = jugador.contador_componente.basuras_actuales

	#data.CantidadBasura = Spawner.cantidad_a_spawnear

	#Para cuando se actulize la cantida de basura que hay en el juego
	#data.CantidadBasura = jugador.contador_componente.cantidad_de_basuras

	ResourceSaver.save(data, "user://save.res")


func Loand_Game() -> void:
	# var Spawner = spawner.new()

	if ResourceLoader.exists("user://save.res"):
		var data = load("user://save.res")
		player.global_position = data.playerPosition

		if data.GuardadoInventario != null:
			Inventario.load_backpack_data(data.GuardadoInventario)

		jugador.energia_componente.energia = data.Penergia
		jugador.contador_componente.set_limpieza(data.Plimpieza)
		Dinero.dinero = data.GuadarDinero

		#Spawner.cantidad_a_spawnear = data.CantidadBasura


func obtener_limpieza(limpieza: int) -> void:
	Porcentaje_Limpieza = limpieza
