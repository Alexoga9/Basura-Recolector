extends Node

var datos_por_escenas: Dictionary = {}# en memoria durante la partida

const ESCENA_INICIAL = "uid://cbesogarip1ji"
const POSICION_INICIAL := Vector2(153.0, 41.0)
const RUTA_SAVE := "user://save.res"


# ------------------------------------------------------------------
# GUARDAR
# ------------------------------------------------------------------
func Guardar() -> void:
	var escena_path := _normalizar(get_tree().current_scene.scene_file_path)

	# 1. Recolectar entidades de la escena actual y actualizar el diccionario en memoria
	var recolector: RecolectorData= get_tree().get_first_node_in_group("RecolectorData")

	if recolector != null:
		recolector.recolectar_todo()
		datos_por_escenas[escena_path] = recolector.serializar()

	# 2. Construir SaveData
	var data := SaveData.new()
	data.escena_actual = escena_path
	data.posicion_jugador = Global.jugador.movimiento_componente.body_character.global_position
	data.dinero = Dinero.dinero
	data.peso_basura = Inventario.peso
	data.energia_actual = Global.jugador.energia_componente.energia
	data.niveles_de_mejoras = NivelesDeExperiencia.serializar()
	data.mochila_inventario = Inventario.get_backpack_data()
	data.datos_por_escenas = datos_por_escenas

	# 3. Persistir
	var err := ResourceSaver.save(data, RUTA_SAVE)

	if err != OK:
		push_error("Error al guardar: ", err)


# ------------------------------------------------------------------
# CARGAR
# ------------------------------------------------------------------
func Cargar() -> void:
	if not ResourceLoader.exists(RUTA_SAVE):
		return

	var data: SaveData = load(RUTA_SAVE) as SaveData

	if data == null:
		push_error("No se pudo cargar el save")
		return

	datos_por_escenas = data.datos_por_escenas

	if data.escena_actual != _normalizar(get_tree().current_scene.scene_file_path):
		get_tree().change_scene_to_file(data.escena_actual)
		await get_tree().process_frame

	var datos_escena: Dictionary = datos_por_escenas.get(data.escena_actual, {})

	if not datos_escena.is_empty():
		var reconstructor := get_tree().get_first_node_in_group("ReconstructorData")

		if reconstructor != null:
			await reconstructor.restaurar(datos_escena)

	# Restaurar estado del jugador
	var jugador := Global.jugador
	jugador.movimiento_componente.body_character.global_position = data.posicion_jugador
	jugador.energia_componente.energia = data.energia_actual

	# Restaurar datos globales
	Dinero.dinero = data.dinero
	NivelesDeExperiencia.deserializar(data.niveles_de_mejoras)
	Inventario.load_backpack_data(data.mochila_inventario)


# ------------------------------------------------------------------
# CAMBIO DE ESCENA (durante la partida)
# ------------------------------------------------------------------
func Cambiar_Escena(ruta_escena: String) -> void:
	ruta_escena = _normalizar(ruta_escena)
	var escena_actual := _normalizar(get_tree().current_scene.scene_file_path)
	var recolector := get_tree().get_first_node_in_group("RecolectorData")

	if recolector != null:
		recolector.recolectar_todo()
		var serializado: Dictionary= recolector.serializar()
		print("[DEBUG] Serializado '", escena_actual, "': ", serializado)
		datos_por_escenas[escena_actual] = serializado
	else:
		print("[DEBUG] ERROR: no hay RecolectorData")

	get_tree().change_scene_to_file(ruta_escena)
	await get_tree().process_frame

	var datos_destino: Dictionary = datos_por_escenas.get(ruta_escena, {})
	print("[DEBUG] Claves guardadas: ", datos_por_escenas.keys())
	print("[DEBUG] Datos destino para '", ruta_escena, "': ", datos_destino)

	if not datos_destino.is_empty():
		var reconstructor := get_tree().get_first_node_in_group("ReconstructorData")

		if reconstructor != null:
			await reconstructor.restaurar(datos_destino)
		else:
			print("[DEBUG] ERROR: no hay ReconstructorData")


func _normalizar(ruta: String) -> String:
	if ruta.begins_with("uid://"):
		return ResourceUID.ensure_path(ruta)

	return ruta


# ------------------------------------------------------------------
# RESET
# ------------------------------------------------------------------
func Reset_Game() -> void:
	datos_por_escenas.clear()
	Dinero.dinero = 0
	Inventario.reset()
	NivelesDeExperiencia.reset()

	if FileAccess.file_exists(RUTA_SAVE):
		DirAccess.remove_absolute(RUTA_SAVE)

	var jugador_viejo = Global.jugador
	get_tree().change_scene_to_file(ESCENA_INICIAL)
	await get_tree().process_frame
