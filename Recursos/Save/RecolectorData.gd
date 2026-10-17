extends Node

# ------------------------------------------------------------------
# Datos recolectados
# ------------------------------------------------------------------
var nombre_escena: String = ""
var terreno: Node2D = null
var jugador: Jugador = null
var basuras: Array[Basura] = []
var loots: Array[Loot] = []
var notas: Array[Notas] = []
var estaciones: Array[StaticBody2D] = []
var estaciones_rotas: Array[EstacionRota] = []
var vallas: Array[pueta_valla] = []

var mochila_inventario: Dictionary
var dinero: int = 0
var peso_basura: int = 0
var energia_actual: int= 0
var niveles_de_mejoras: Dictionary
# compara la cantidad de basuras con un antes y un despues, sacando un porcentaje
# es decir habian 100 cajas, ahora quedan 50, eso es el 50% que se recogio
var estado_de_limpieza: int= 0


func _ready():
	call_deferred("recolectar_todo")


# ------------------------------------------------------------------
# Recolección
# ------------------------------------------------------------------
func recolectar_todo() -> void:
	nombre_escena = _nombre_de_grupo("Chunk")
	terreno = _nodo_de_grupo("CapaSucia") as Node2D
	jugador = _nodo_de_grupo("Jugador") as Jugador

	dinero = int(Dinero.dinero)
	energia_actual = int(jugador.energia_componente.energia)
	peso_basura = Inventario.peso
	mochila_inventario = Inventario.get_backpack_data()
	niveles_de_mejoras = NivelesDeExperiencia.serializar()

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

	destino.assign(contenedor.get_children())


# ------------------------------------------------------------------
# Serialización
# ------------------------------------------------------------------
func serializar() -> Dictionary:
	return {
		"CarpetaBasuras": _serializar_carpeta(basuras),
		"CarpetaLoot": _serializar_carpeta(loots),
		"CarpetaNotas": _serializar_carpeta(notas),
		"CarpetaEstaciones": _serializar_carpeta(estaciones),
		"CarpetaEstacionesRotas": _serializar_carpeta(estaciones_rotas),
		"CarpetaVallas": _serializar_carpeta(vallas),
	}


## Serializa una carpeta: { escena: uid, entradas: [ {recurso, posicion}, ... ] }
func _serializar_carpeta(lista: Array) -> Dictionary:
	var uid_escena := _uid_de_lista(lista)
	var entradas: Array = []

	for nodo in lista:
		if not is_instance_valid(nodo):
			continue

		if not (nodo is Node2D):
			continue

		entradas.append(_serializar_nodo(nodo))

	return {
		"escena": uid_escena,
		"entradas": entradas,
	}


## Serializa un nodo: { recurso, posicion }
func _serializar_nodo(nodo: Node) -> Dictionary:
	var entrada := {
		"recurso": "",
		"posicion": nodo.position,
	}

	if "data" in nodo and nodo.data != null:
		entrada["recurso"] = nodo.data.resource_path

	return entrada


## Devuelve el UID de la escena del primer nodo válido de la lista.
## Si la lista está vacía o no se puede resolver, devuelve "".
func _uid_de_lista(lista: Array) -> String:
	for nodo in lista:
		if not is_instance_valid(nodo):
			continue

		var uid := _uid_de_nodo(nodo)

		if uid != "":
			return uid

	return ""


## Devuelve el UID de la escena de la que proviene un nodo.
func _uid_de_nodo(nodo: Node) -> String:
	var ruta := nodo.scene_file_path

	if ruta == "":
		return ""

	var uid_int := ResourceLoader.get_resource_uid(ruta)

	if uid_int == ResourceUID.INVALID_ID:
		return ""

	return ResourceUID.id_to_text(uid_int)
