class_name save_game extends Node

var jugador: Jugador
var Porcentaje_Limpieza: int
var datos_por_escenas: Dictionary = {}# vive en memoria durante toda la partida


func guardar_estado_escena_actual() -> void:
	var escena_actual = get_tree().current_scene

	if escena_actual == null:
		push_warning("No hay escena actual, no se puede cargar estado.")
		return

	var ruta = escena_actual.scene_file_path
	var estado := {}

	for objeto in get_tree().get_nodes_in_group("guardables"):
		estado[str(objeto.get_path())] = objeto.obtener_datos()

	datos_por_escenas[ruta] = estado


func cargar_estado_escena_actual() -> void:

	var escena_actual = get_tree().current_scene

	if escena_actual == null:
		push_warning("No hay escena actual, no se puede cargar estado.")
		return

	var ruta = escena_actual.scene_file_path

	if datos_por_escenas.has(ruta):
		var estado = datos_por_escenas[ruta]

		for objeto in get_tree().get_nodes_in_group("guardables"):
			var clave = str(objeto.get_path())

			if estado.has(clave):
				objeto.aplicar_datos(estado[clave])


func Save_Game() -> void:
	guardar_estado_escena_actual() # deja al día la escena actual antes de escribir

	var data = SaveData.new()
	data.SceneName = get_tree().current_scene.scene_file_path
	data.GuadarDinero = Dinero.dinero

	jugador = Global.jugador

	data.playerPosition = jugador.movimiento_componente.body_character.global_position
	data.GuardadoInventario = Inventario.get_backpack_data()
	data.Penergia = jugador.energia_componente.energia
	data.Plimpieza = jugador.contador_componente.basuras_actuales
	data.datos_por_escenas = datos_por_escenas # el dict COMPLETO en memoria

	ResourceSaver.save(data, "user://save.res") # sobrescribe todo el archivo, siempre


func Load_Game() -> void:
	if not ResourceLoader.exists("user://save.res"):
		return

	var data: SaveData = load("user://save.res")
	datos_por_escenas = data.datos_por_escenas # repuebla la memoria desde disco

	if data.SceneName != get_tree().current_scene.scene_file_path:
		get_tree().change_scene_to_file(data.SceneName)
		await get_tree().process_frame

	jugador = Global.jugador
	jugador.movimiento_componente.body_character.global_position = data.playerPosition

	if data.GuardadoInventario != null:
		Inventario.load_backpack_data(data.GuardadoInventario)

	jugador.energia_componente.energia = data.Penergia
	jugador.contador_componente.set_limpieza(data.Plimpieza)
	Dinero.dinero = data.GuadarDinero

	cargar_estado_escena_actual()
