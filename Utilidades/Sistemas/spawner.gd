class_name spawner extends Node2D

@export var cantidad_a_spawnear: int = 10
@export var point_1: Marker2D
@export var point_2: Marker2D
@export var prefab: PackedScene

var objetos_spawneados: Array = []
var area_spawn_rect: Rect2


func _ready() -> void:
	calcular_area_spawn()
	loop_de_spawneo()


func calcular_area_spawn() -> void:
	var min_x = min(point_1.global_position.x, point_2.global_position.x)
	var max_x = max(point_1.global_position.x, point_2.global_position.x)
	var min_y = min(point_1.global_position.y, point_2.global_position.y)
	var max_y = max(point_1.global_position.y, point_2.global_position.y)

	area_spawn_rect = Rect2(min_x, min_y, max_x - min_x, max_y - min_y)


func loop_de_spawneo() -> void:
	for i in range(cantidad_a_spawnear):
		spawnear(i)


func spawnear(indice: int) -> void:
	var contenedor = get_tree().get_first_node_in_group("EntidadesBasuras")

	if contenedor == null:
		push_error("No se encontró el grupo 'EntidadesBasuras'")
		return

	var nueva_instancia = prefab.instantiate()
	#nueva_instancia = "%s_%d" % [name, indice] # ID estable para el guardado

	contenedor.add_child(nueva_instancia)
	nueva_instancia.global_position = Vector2(
		randf_range(area_spawn_rect.position.x, area_spawn_rect.end.x),
		randf_range(area_spawn_rect.position.y, area_spawn_rect.end.y)

	)

	objetos_spawneados.append(nueva_instancia)
	nueva_instancia.tree_exited.connect(eraser.bind(nueva_instancia))


func eraser(nueva_instancia) -> void:
	objetos_spawneados.erase(nueva_instancia)
