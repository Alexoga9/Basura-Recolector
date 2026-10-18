class_name RecolectorData extends Node

# ------------------------------------------------------------------
# Datos recolectados
# (arrays sin tipo: un Array[T] tipado falla con assign() si algún hijo
#  de la carpeta no es exactamente de ese tipo)
# ------------------------------------------------------------------
var nombre_escena: String = ""
var terreno: Node2D = null
var jugador: Jugador = null
var basuras: Array = []
var loots: Array = []
var notas: Array = []
var estaciones: Array = []
var estaciones_rotas: Array = []
var vallas: Array = []

# compara la cantidad de basuras con un antes y un despues, sacando un porcentaje
# es decir habian 100 cajas, ahora quedan 50, eso es el 50% que se recogio
var estado_de_limpieza: int = 0


func _ready() -> void:
	call_deferred("recolectar_todo")


# ------------------------------------------------------------------
# Recolección
# ------------------------------------------------------------------
func recolectar_todo() -> void:
	nombre_escena = _nombre_de_grupo("Chunk")
	terreno = _nodo_de_grupo("CapaSucia") as Node2D
	jugador = _nodo_de_grupo("Jugador") as Jugador

	_recoger_hijos("EntidadesBasuras", basuras)
	_recoger_hijos("EntidadesLoot", loots)
	_recoger_hijos("Entidades Notas", notas)
	_recoger_hijos("EstacionesNormales", estaciones)
	_recoger_hijos("EstacionesRotas", estaciones_rotas)
	_recoger_hijos("EntidadesVallas", vallas)


func _nodo_de_grupo(grupo: StringName) -> Node:
	return get_tree().get_first_node_in_group(grupo)


func _nombre_de_grupo(grupo: StringName) -> String:
	var n := _nodo_de_grupo(grupo)
	return n.name if n != null else ""


func _recoger_hijos(grupo: StringName, destino: Array) -> void:
	destino.clear()
	var contenedor := _nodo_de_grupo(grupo)

	if contenedor == null:
		return

	for hijo in contenedor.get_children():
		# ignorar nodos que ya se están eliminando
		if hijo.is_queued_for_deletion():
			continue
		destino.append(hijo)


# ------------------------------------------------------------------
# Serialización
# ------------------------------------------------------------------
func serializar() -> Dictionary:
	return {
		"EntidadesBasuras": _serializar_carpeta(basuras),
		"EntidadesLoot": _serializar_carpeta(loots),
		"Entidades Notas": _serializar_carpeta(notas),
		"EstacionesNormales": _serializar_carpeta(estaciones),
		"EstacionesRotas": _serializar_carpeta(estaciones_rotas),
		"EntidadesVallas": _serializar_carpeta(vallas),
	}


## Serializa una carpeta: { entradas: [ {escena, recurso, posicion, props}, ... ] }
## Una carpeta vacía devuelve entradas = [] (significa "todo fue recogido").
func _serializar_carpeta(lista: Array) -> Dictionary:
	var entradas: Array = []

	for nodo in lista:
		if not is_instance_valid(nodo):
			continue

		if not (nodo is Node2D):
			continue

		entradas.append(_serializar_nodo(nodo))

	return {
		"entradas": entradas,
	}


## Serializa un nodo: { escena, recurso, posicion, props }
## - escena: ruta de la escena de ESE nodo (ya no una sola por carpeta)
## - recurso: resource_path de nodo.data (opcional)
## - props: diccionario opcional si el nodo implementa serializar_estado()
func _serializar_nodo(nodo: Node2D) -> Dictionary:
	var entrada := {
		"escena": nodo.scene_file_path,
		"recurso": "",
		"posicion": nodo.position,
		"props": {},
	}

	if "data" in nodo and nodo.data != null:
		entrada["recurso"] = nodo.data.resource_path

	if nodo.has_method("serializar_estado"):
		entrada["props"] = nodo.serializar_estado()

	return entrada
