extends Node
@export var player: Node2D
var jugador:Jugador
var Porcentaje_Limpieza: int


func _ready() -> void:
	jugador = Global.jugador
	SignalBus.zona_limpida.connect(obtener_limpieza)


func Save_Game() -> void:
	var data = SaveData.new()

	data.playerPosition = player.global_position
	data.Plimpieza = Porcentaje_Limpieza
	data.Pbasura = Inventario.get_count("Basura")
	data.LotDefinicion = Inventario.get_item_resource("Basura")
	data.Penergia = jugador.energia_componente.energia

	ResourceSaver.save(data, "user://save.res")


func Loand_Game() -> void:
	if ResourceLoader.exists("user://save.res"):
		var data = load("user://save.res")
		player.global_position = data.playerPosition

		if data.LotDefinicion != null:
			Inventario.add_item(data.LotDefinicion, data.Pbasura)

		jugador.energia_componente.energia = data.Penergia
		SignalBus.zona_limpida.emit(data.Plimpieza)


func obtener_limpieza(limpieza: int) -> void:
	Porcentaje_Limpieza = limpieza
	print(str(Porcentaje_Limpieza))
