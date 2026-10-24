class_name ContadorComponente extends Node

signal limpieza_actualizada(porcentaje: int)

## Cantidad ORIGINAL de basuras que tenía la escena la primera vez que se entró.
## Se guarda en el save y nunca se vuelve a recalcular contando nodos.
var cantidad_de_basuras: int = 1 # evita división entre 0

## Basuras recogidas hasta ahora en esta escena.
var basuras_actuales: int = 0

var _inicializado: bool = false


func _ready() -> void:
	if not SignalBus.basura_recogida.is_connected(añadir_basura):
		SignalBus.basura_recogida.connect(añadir_basura)

	# Esperamos a que la escena termine de montarse
	await get_tree().process_frame

	# Si SaveGame ya restauró el estado antes de este punto, no lo pisamos
	if _inicializado:
		return

	var guardado: Dictionary = SaveGame.get_limpieza_guardada(_ruta_escena_actual())

	if not guardado.is_empty():
		# Escena ya visitada: usamos el total ORIGINAL guardado
		_aplicar(int(guardado.get("total", 1)), int(guardado.get("recogidas", 0)))
	else:
		# Primera visita: lo que hay ahora ES el total original
		_aplicar(_contar_basuras_en_escena(), 0)

	await get_tree().process_frame
	_emitir_porcentaje()


# ------------------------------------------------------------------
# Lectura
# ------------------------------------------------------------------
func basuras_restantes() -> int:
	return maxi(cantidad_de_basuras - basuras_actuales, 0)


func get_porcentaje() -> int:
	return int((float(basuras_actuales) / cantidad_de_basuras) * 100)


# ------------------------------------------------------------------
# Escritura
# ------------------------------------------------------------------
func añadir_basura() -> void:
	basuras_actuales = mini(basuras_actuales + 1, cantidad_de_basuras)
	_emitir_porcentaje()


## Compatibilidad: antes recibía (mal nombrado) la cantidad de recogidas.
func set_limpieza(recogidas: int) -> void:
	basuras_actuales = clampi(recogidas, 0, cantidad_de_basuras)
	_emitir_porcentaje()


## Lo llama SaveGame después de restaurar la escena.
## 'reconciliar': si el reconstructor ya recreó las basuras, el número real
## de nodos manda sobre el guardado (recogidas = total - las que quedan).
func cargar_estado(total: int, recogidas: int, reconciliar: bool = false) -> void:
	_aplicar(total, recogidas)

	if reconciliar:
		var reales := _contar_basuras_en_escena()
		basuras_actuales = clampi(cantidad_de_basuras - reales, 0, cantidad_de_basuras)

	_emitir_porcentaje()


## Lo usa SaveGame al guardar la escena.
func exportar() -> Dictionary:
	return {
		"total": cantidad_de_basuras,
		"recogidas": basuras_actuales,
	}


# ------------------------------------------------------------------
# Internos
# ------------------------------------------------------------------
func _aplicar(total: int, recogidas: int) -> void:
	cantidad_de_basuras = maxi(total, 1)
	basuras_actuales = clampi(recogidas, 0, cantidad_de_basuras)
	_inicializado = true


func _contar_basuras_en_escena() -> int:
	var n := 0

	for b in get_tree().get_nodes_in_group("Basura"):
		if not b.is_queued_for_deletion():
			n += 1

	return n


func _ruta_escena_actual() -> String:
	var escena := get_tree().current_scene

	return escena.scene_file_path if escena != null else ""


func _emitir_porcentaje() -> void:
	limpieza_actualizada.emit(get_porcentaje())
	SignalBus.zona_limpida.emit(get_porcentaje())
