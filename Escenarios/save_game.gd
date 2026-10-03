class_name save_game extends Node

var jugador: Jugador
var Porcentaje_Limpieza: int
var datos_por_escenas: Dictionary = {}# vive en memoria durante toda la partida

# reset
const ESCENA_INICIAL = "uid://cbesogarip1ji"
const POSICION_INICIAL := Vector2(153.0, 41.0)


func guardar_estado_escena_actual() -> void:
	var escena_actual = get_tree().current_scene

	if escena_actual == null:
		return

	var ruta = escena_actual.scene_file_path

	# Obtenemos lo que ya estaba guardado para no borrar items ya recogidos
	var estado = datos_por_escenas.get(ruta, {})
	var guardable = get_tree().get_nodes_in_group("guardables")

	for guardar in guardable:
		if guardar.has_method("obtener_datos") and "id_guardado" in guardar:
			estado[guardar.id_guardado] = guardar.obtener_datos()

	datos_por_escenas[ruta] = estado


func cargar_estado_escena_actual() -> void:
	var escena_actual = get_tree().current_scene

	if escena_actual == null:
		return

	var ruta = escena_actual.scene_file_path

	if datos_por_escenas.has(ruta):
		var estado = datos_por_escenas[ruta]

		for objeto in get_tree().get_nodes_in_group("guardables"):
			if "id_guardado" in objeto:
				var clave = objeto.id_guardado

				if estado.has(clave):
					objeto.aplicar_datos(estado[clave])


func Save_Game() -> void:
	guardar_estado_escena_actual()

	var data = SaveData.new()
	data.SceneName = get_tree().current_scene.scene_file_path
	data.GuadarDinero = Dinero.dinero
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

	cargar_estado_escena_actual()


func cambiar_escena(ruta: String, autoguardar: bool = true) -> void:
	guardar_estado_escena_actual() # 1. Guarda la escena actual antes de salir

	get_tree().change_scene_to_file(ruta)

	# 2. Espera a que la escena nueva y el jugador estén completamente cargados
	await get_tree().process_frame
	while get_tree().current_scene == null \
	or not is_instance_valid(Global.jugador) \
	or not Global.jugador.is_inside_tree():
		await get_tree().process_frame

	jugador = Global.jugador

	# 3. Como los objetos ya están colocados a mano en la escena, 
	#    simplemente cargamos su estado (ej. destruimos los que ya recogiste)
	cargar_estado_escena_actual()

	if autoguardar:
		Save_Game() # 4. Guarda a disco el nuevo estado


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


# Llama a esto justo antes de usar queue_free() en el objeto recogido
func registrar_item_destruido(id_guardado: String) -> void:
	var escena_actual = get_tree().current_scene

	if escena_actual == null: return

	var ruta = escena_actual.scene_file_path

	if not datos_por_escenas.has(ruta):
		datos_por_escenas[ruta] = {}

	datos_por_escenas[ruta][id_guardado] = {"recogida": true}
