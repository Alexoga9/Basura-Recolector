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


func deletefile() -> void:
	if ResourceLoader.exists("user://save.res"):
		Dinero.dinero = 0
		player.global_position = Vector2(153.0, 41)
		Porcentaje_Limpieza = 0
		jugador.contador_componente.set_limpieza(Porcentaje_Limpieza)
		Inventario.reset()
		jugador.energia_componente.energia = 0
		jugador.contador_componente.basuras_actuales = 0
		DirAccess.remove_absolute("user://save.res")


func obtener_limpieza(limpieza: int) -> void:
	Porcentaje_Limpieza = limpieza
