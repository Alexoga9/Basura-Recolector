class_name ReconstructorData extends Node


## Restaura las entidades de la escena a partir de un diccionario
## producido por RecolectorData.
##
## Formato esperado:
## {
##   "EntidadesBasuras": { "escena": "uid://...", "entradas": [ {recurso, posicion}, ... ] },
##   ...
## }
func restaurar(datos: Dictionary) -> void:
	print("Restaurando...")
	if datos.is_empty():
		return

	for nombre_grupo in datos:
		var info: Dictionary = datos[nombre_grupo]
		await _restaurar_carpeta(nombre_grupo, info)


func _restaurar_carpeta(nombre_grupo: String, info: Dictionary) -> void:

	var carpeta := _obtener_carpeta_por_grupo(nombre_grupo)

	if carpeta == null:
		push_warning("Reconstructor: no se encontró carpeta en el grupo '", nombre_grupo, "'")
		return

	# 1. Borrar hijos actuales
	_borrar_hijos(carpeta)

	# 2. Esperar a que se liberen
	await get_tree().process_frame

	# 3. Obtener la escena desde el UID
	var uid: String = info.get("escena", "")

	if uid == "":
		push_warning("Reconstructor: grupo '", nombre_grupo, "' sin UID de escena")
		return

	var escena := load(uid) as PackedScene

	if escena == null:
		push_warning("Reconstructor: no se pudo cargar la escena '", uid, "'")
		return

	# 4. Instanciar cada entrada
	for entrada in info.get("entradas", []):
		if not (entrada is Dictionary):
			continue

		_instanciar_entrada(carpeta, escena, entrada, nombre_grupo)


func _borrar_hijos(carpeta: Node) -> void:
	for hijo in carpeta.get_children():
		hijo.queue_free()


func _instanciar_entrada(carpeta: Node, escena: PackedScene, entrada: Dictionary, grupo: String) -> void:
	var ruta: String = entrada.get("recurso", "")

	if ruta == "":
		return

	var recurso := load(ruta)

	if recurso == null:
		push_warning("Reconstructor [", grupo, "]: no se pudo cargar recurso '", ruta, "'")
		return

	var nodo := escena.instantiate()

	if "data" in nodo:
		nodo.data = recurso
	else:
		push_warning("Reconstructor [", grupo, "]: el nodo instanciado no tiene propiedad 'data'")

	carpeta.add_child(nodo)

	if entrada.has("posicion"):
		nodo.position = entrada["posicion"]


func _obtener_carpeta_por_grupo(nombre_grupo: String) -> Node:
	return get_tree().get_first_node_in_group(StringName(nombre_grupo))
