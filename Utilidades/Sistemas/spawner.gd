class_name spawner extends Node2D

@export var cantidad_a_spawnear: int = 10
@export var point_1: Marker2D
@export var point_2: Marker2D
@export var prefab: PackedScene
@export var spawnear_al_iniciar: bool = true

var objetos_spawneados: Array = []
var area_spawn_rect: Rect2


func _ready() -> void:
	Global.Spawner = self

	if spawnear_al_iniciar:
		generar()


func _exit_tree() -> void:
	if Global.Spawner == self:
		Global.Spawner = null


# Función pública: se puede llamar desde otro script
func generar(cantidad: int = -1) -> void:

	if cantidad >= 0:
		cantidad_a_spawnear = cantidad

	limpiar()
	calcular_area_spawn()

	for i in range(cantidad_a_spawnear):
		spawnear(i)


func limpiar() -> void:
	for objeto in objetos_spawneados.duplicate():
		if is_instance_valid(objeto):
			objeto.queue_free()

	objetos_spawneados.clear()


func calcular_area_spawn() -> void:
	var min_x = min(point_1.global_position.x, point_2.global_position.x)
	var max_x = max(point_1.global_position.x, point_2.global_position.x)
	var min_y = min(point_1.global_position.y, point_2.global_position.y)
	var max_y = max(point_1.global_position.y, point_2.global_position.y)

	area_spawn_rect = Rect2(min_x, min_y, max_x - min_x, max_y - min_y)


func spawnear(indice: int) -> void:
	var contenedor = get_tree().get_first_node_in_group("EntidadesBasuras")

	if contenedor == null:
		push_error("No se encontró el grupo 'EntidadesBasuras'")
		return

	var nueva_instancia = prefab.instantiate()

	# ESTO ES LO NUEVO: Fijamos el nombre del nodo y le damos un ID único
	nueva_instancia.name = "Spawn_%s_%d" % [name, indice]
	nueva_instancia.id_guardado = "%s_%s_%d" % [get_tree().current_scene.name, name, indice]

	contenedor.add_child(nueva_instancia)
	nueva_instancia.global_position = Vector2(
		randf_range(area_spawn_rect.position.x, area_spawn_rect.end.x),
		randf_range(area_spawn_rect.position.y, area_spawn_rect.end.y)

	)

	objetos_spawneados.append(nueva_instancia)
	nueva_instancia.tree_exited.connect(eraser.bind(nueva_instancia))


func eraser(nueva_instancia) -> void:
	objetos_spawneados.erase(nueva_instancia)
