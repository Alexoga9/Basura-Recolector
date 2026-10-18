class_name ReconstructorData extends Node


## Restaura las entidades de la escena a partir de un diccionario
## producido por RecolectorData.
##
## Formato esperado:
## {
##   "EntidadesBasuras": { "entradas": [ {escena, recurso, posicion, props}, ... ] },
##   ...
## }
func restaurar(datos: Dictionary) -> void:
	if datos.is_empty():
		return

	for nombre_grupo in datos:
		var info: Dictionary = datos[nombre_grupo]
		_restaurar_carpeta(String(nombre_grupo), info)


func _restaurar_carpeta(nombre_grupo: String, info: Dictionary) -> void:
	var carpeta := _obtener_carpeta_por_grupo(nombre_grupo)

	if carpeta == null:
		push_warning("Reconstructor: no se encontró carpeta en el grupo '%s'" % nombre_grupo)
		return

	# 1. Borrar hijos actuales (remove_child inmediato para evitar choques de nombres)
	_borrar_hijos(carpeta)

	# 2. Instanciar cada entrada (si no hay entradas, la carpeta queda vacía a propósito)
	var escena_por_defecto: String = info.get("escena", "") # compatibilidad con saves viejos

	for entrada in info.get("entradas", []):
		if not (entrada is Dictionary):
			continue

		_instanciar_entrada(carpeta, entrada, escena_por_defecto, nombre_grupo)


func _borrar_hijos(carpeta: Node) -> void:
	for hijo in carpeta.get_children():
		carpeta.remove_child(hijo)
		hijo.queue_free()


func _instanciar_entrada(carpeta: Node, entrada: Dictionary, escena_por_defecto: String, grupo: String) -> void:
	# --- Escena del nodo ---
	var ruta_escena: String = entrada.get("escena", escena_por_defecto)

	if ruta_escena == "":
		push_warning("Reconstructor [%s]: entrada sin escena" % grupo)
		return

	var escena := load(ruta_escena) as PackedScene

	if escena == null:
		push_warning("Reconstructor [%s]: no se pudo cargar la escena '%s'" % [grupo, ruta_escena])
		return

	var nodo := escena.instantiate()

	# --- Recurso 'data' (opcional) ---
	var ruta_recurso: String = entrada.get("recurso", "")

	if ruta_recurso != "":
		var recurso := load(ruta_recurso)

		if recurso == null:
			push_warning("Reconstructor [%s]: no se pudo cargar recurso '%s'" % [grupo, ruta_recurso])
		elif "data" in nodo:
			nodo.data = recurso
		else:
			push_warning("Reconstructor [%s]: el nodo no tiene propiedad 'data'" % grupo)

	# --- Propiedades extra (antes de add_child, para que _ready ya las vea) ---
	var props: Dictionary = entrada.get("props", {})

	if not props.is_empty() and nodo.has_method("restaurar_estado"):
		nodo.restaurar_estado(props)

	# --- Posición y añadir ---
	if entrada.has("posicion"):
		nodo.position = entrada["posicion"]

	carpeta.add_child(nodo)


func _obtener_carpeta_por_grupo(nombre_grupo: String) -> Node:
	return get_tree().get_first_node_in_group(StringName(nombre_grupo))
