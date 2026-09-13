class_name ContadorComponente extends Node

signal limpieza_actualizada(porcentaje: int)

var basuras_actuales: int = 0
var cantidad_de_basuras: int = 1 # evita división entre 0


func _ready() -> void:
	cantidad_de_basuras = get_tree().get_node_count_in_group("Basura")

	if cantidad_de_basuras <= 0:
		cantidad_de_basuras = 1

	SignalBus.basura_recogida.connect(añadir_basura)
	await get_tree().process_frame
	_emitir_porcentaje()


func añadir_basura() -> void:
	basuras_actuales += 1
	_emitir_porcentaje()


func set_limpieza(porcentaje_guardado: int) -> void:
	basuras_actuales = porcentaje_guardado
	_emitir_porcentaje()


func get_porcentaje() -> int:
	return int((float(basuras_actuales) / cantidad_de_basuras) * 100)


func _emitir_porcentaje() -> void:
	limpieza_actualizada.emit(get_porcentaje())
	SignalBus.zona_limpida.emit(get_porcentaje())
