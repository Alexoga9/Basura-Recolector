extends Node

var datos_por_escenas: Dictionary = {} # en memoria durante la partida

const ESCENA_INICIAL = "uid://cbesogarip1ji"
const POSICION_INICIAL := Vector2(153.0, 41.0)
const RUTA_SAVE := "user://save.res"


# ------------------------------------------------------------------
# UTILIDADES
# ------------------------------------------------------------------

## Convierte cualquier ruta (uid:// o res://) a ruta res:// para usarla
## SIEMPRE como clave de datos_por_escenas. Este era el bug principal:
## se guardaba con res:// y se buscaba con uid://.
func _normalizar(ruta: String) -> String:
	if ruta.begins_with("uid://"):
		var id := ResourceUID.text_to_id(ruta)
		if ResourceUID.has_id(id):
			return ResourceUID.get_id_path(id)
	return ruta


## Recolecta la escena actual y guarda su estado en memoria.
func _registrar_escena_actual() -> void:
	var escena := get_tree().current_scene
	if escena == null:
		return

	var clave := _normalizar(escena.scene_file_path)
	var recolector := get_tree().get_first_node_in_group("RecolectorData") as RecolectorData

	if recolector == null:
		push_warning("SaveGame: no hay RecolectorData en '%s'" % clave)
		return

	recolector.recolectar_todo()
	datos_por_escenas[clave] = recolector.serializar()


## Restaura la escena actual con lo que haya en memoria.
func _restaurar_escena_actual() -> void:
	var clave := _normalizar(get_tree().current_scene.scene_file_path)
	var datos: Dictionary = datos_por_escenas.get(clave, {})

	if datos.is_empty():
		return

	var reconstructor := get_tree().get_first_node_in_group("ReconstructorData") as ReconstructorData

	if reconstructor == null:
		push_warning("SaveGame: no hay ReconstructorData en '%s'" % clave)
		return

	await reconstructor.restaurar(datos)


## Espera a que la escena nueva esté realmente lista.
func _esperar_escena_nueva() -> void:
	await get_tree().process_frame
	await get_tree().process_frame


# ------------------------------------------------------------------
# GUARDAR
# ------------------------------------------------------------------
func Guardar() -> void:
	# 1. Recolectar la escena actual
	_registrar_escena_actual()

	# 2. Construir SaveData
	var data := SaveData.new()
	data.escena_actual = _normalizar(get_tree().current_scene.scene_file_path)
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
		push_error("Error al guardar: %s" % err)


# ------------------------------------------------------------------
# CARGAR
# ------------------------------------------------------------------
func Cargar() -> void:
	if not ResourceLoader.exists(RUTA_SAVE):
		return

	# CACHE_MODE_IGNORE: evita recibir una versión vieja cacheada del save
	var data := ResourceLoader.load(RUTA_SAVE, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveData

	if data == null:
		push_error("No se pudo cargar el save")
		return

	# Normalizar claves (por si hay saves antiguos con uid://)
	datos_por_escenas = {}
	for clave in data.datos_por_escenas:
		datos_por_escenas[_normalizar(String(clave))] = data.datos_por_escenas[clave]

	var escena_guardada := _normalizar(data.escena_actual)

	if escena_guardada != _normalizar(get_tree().current_scene.scene_file_path):
		get_tree().change_scene_to_file(escena_guardada)
		await _esperar_escena_nueva()

	await _restaurar_escena_actual()

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

	# Guardar el estado de la escena de la que salimos
	_registrar_escena_actual()

	get_tree().change_scene_to_file(ruta_escena)
	await _esperar_escena_nueva()

	# Restaurar el estado de la escena a la que entramos (si ya la visitamos)
	await _restaurar_escena_actual()


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

	get_tree().change_scene_to_file(_normalizar(ESCENA_INICIAL))
	await _esperar_escena_nueva()
