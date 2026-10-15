extends Node

## lugar en el que se recopila toda la información que se
## va a guardar a través del juego

var nombre_escena: String
var terreno: Node2D
var jugador: Jugador
var basuras: Array[Basura] = []
var loots: Array[Loot] = []
var notas: Array[Notas] = []
var estaciones: Array[StaticBody2D] #Grupo
var estaciones_rotas: Array[EstacionRota] = []
var vallas: Array[pueta_valla] = []


func _ready():
	pass


## La función para que todo se recolecte 
func recolectar_datos():
	get_chunk_name()
	get_terreno()
	get_jugador()
	get_basuras()
	get_loot()
	get_notas()
	get_estaciones()
	get_estaciones_rotas()
	get_vallas()


func get_chunk_name():
	nombre_escena = get_tree().get_first_node_in_group("Chunk").name


func get_terreno():
	terreno = get_tree().get_first_node_in_group("CapaSucia")


func get_jugador():
	jugador = get_tree().get_first_node_in_group("Jugador")


func get_basuras():
	basuras.clear()
	basuras.append_array(get_tree().get_first_node_in_group("EntidadesBasuras").get_children())


func get_loot():
	loots.clear()
	loots.append_array(get_tree().get_first_node_in_group("EntidadesLoot").get_children())


func get_notas():
	notas.clear()
	notas.append_array(get_tree().get_first_node_in_group("Entidades Notas").get_children())


func get_estaciones():
	estaciones.clear()
	estaciones.append_array(get_tree().get_first_node_in_group("EstacionesNormales").get_children())


func get_estaciones_rotas():
	estaciones_rotas.clear()
	estaciones_rotas.append_array(get_tree().get_first_node_in_group("EstacionesRotas").get_children())


func get_vallas():
	vallas.clear()
	vallas.append_array(get_tree().get_first_node_in_group("EntidadesVallas").get_children())
