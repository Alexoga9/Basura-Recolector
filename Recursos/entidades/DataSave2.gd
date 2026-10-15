extends Node

@export var nombre_escena: String
@export var terreno: Node2D
@export var jugador: Jugador
@export var basuras: Array[Basura]
@export var loots: Array[Loot]
@export var notas: Array[Notas]
@export var estaciones: Array[StaticBody2D] #Grupo
@export var estaciones_rotas: Array[EstacionRota]
@export var vallas: Array[pueta_valla]


func _ready():
	get_chunk_name()
	get_terreno()
	get_jugador()
	get_basuras()
	get_loot()
	get_notas()
	get_estaciones()
	get_estaciones_rotas()
	get_vallas()


## Consigue el nombre del chunk
func get_chunk_name():
	nombre_escena = get_tree().get_first_node_in_group("Chunk").name


func get_terreno():
	terreno = get_tree().get_first_node_in_group("CapaSucia")


func get_jugador():
	jugador = get_tree().get_first_node_in_group("Jugador")


func get_basuras():
	basuras.append_array(get_tree().get_first_node_in_group("EntidadesBasuras").get_children())


func get_loot():
	loots.append_array(get_tree().get_first_node_in_group("EntidadesLoot").get_children())


func get_notas():
	notas.append_array(get_tree().get_first_node_in_group("Entidades Notas").get_children())


func get_estaciones():
	estaciones.append_array(get_tree().get_first_node_in_group("EstacionesNormales").get_children())


func get_estaciones_rotas():
	estaciones_rotas.append_array(get_tree().get_first_node_in_group("EstacionesRotas").get_children())


func get_vallas():
	vallas.append_array(get_tree().get_first_node_in_group("EntidadesVallas").get_children())
