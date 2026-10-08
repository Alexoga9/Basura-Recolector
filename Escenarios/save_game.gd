class_name save_game extends Node

var jugador: Jugador
var Porcentaje_Limpieza: int
var datos_por_escenas: Dictionary = {}# vive en memoria durante toda la partida

# reset
const ESCENA_INICIAL = "uid://cbesogarip1ji"
const POSICION_INICIAL := Vector2(153.0, 41.0)


func Save_Game() -> void:
	var data = SaveData.new()
	data.SceneName = get_tree().current_scene.scene_file_path
	data.GuardarDinero = Dinero.dinero
	jugador = Global.jugador

	data.playerPosition = jugador.movimiento_componente.body_character.global_position
	data.GuardadoInventario = Inventario.get_backpack_data()
	data.Penergia = jugador.energia_componente.energia
	data.Plimpieza = jugador.contador_componente.basuras_actuales
	data.datos_por_escenas = datos_por_escenas

	ResourceSaver.save(data, "user://save.res")


func Load_Game() -> void:
	if not ResourceLoader.exists("user://save.res"):
		return

	var data: SaveData = load("user://save.res")
	datos_por_escenas = data.datos_por_escenas

	if data.SceneName != get_tree().current_scene.scene_file_path:
		get_tree().change_scene_to_file(data.SceneName)
		print(data.SceneName)
		await get_tree().process_frame

	jugador = Global.jugador
	jugador.movimiento_componente.body_character.global_position = data.playerPosition

	if data.GuardadoInventario != null:
		Inventario.load_backpack_data(data.GuardadoInventario)

	jugador.energia_componente.energia = data.Penergia
	jugador.contador_componente.set_limpieza(data.Plimpieza)
	Dinero.dinero = data.GuadarDinero


func Reset_Game() -> void:
	datos_por_escenas.clear()
	Porcentaje_Limpieza = 0
	Dinero.dinero = 0
	Inventario.reset()

	if FileAccess.file_exists("user://save.res"):
		DirAccess.remove_absolute("user://save.res")

	var jugador_viejo = Global.jugador
	get_tree().change_scene_to_file(ESCENA_INICIAL)

	await get_tree().process_frame
	while get_tree().current_scene == null \
	or not is_instance_valid(Global.jugador) \
	or Global.jugador == jugador_viejo:
		await get_tree().process_frame

	jugador = Global.jugador
	jugador.movimiento_componente.body_character.global_position = POSICION_INICIAL
	jugador.energia_componente.energia = 0.0
	jugador.contador_componente.basuras_actuales = 0
	jugador.contador_componente.set_limpieza(0)
