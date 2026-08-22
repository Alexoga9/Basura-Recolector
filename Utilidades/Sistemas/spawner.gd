extends Node2D

@export var cantidad_a_spawnear: int

@export var point_1: Marker2D
@export var point_2: Marker2D

@export var prefab: PackedScene

@onready var area_fantasma: Area2D = %AreaFantasma
@onready var collider_fantasma: CollisionShape2D = %ColisionFantasma

var objetos_spawneados: Array = []

var intentos_maximos: int = 30
var intentos: int = 0
var espacio_disponible: bool = true
var todas_las_instancias_agotadas: bool = false


func _init():
	pass


func _ready():
	randomize()
	conseguir_collishion_shape_2D()
	loop_de_spawneo()


func conseguir_collishion_shape_2D():
	var prefab_temporal = prefab.instantiate()
	var collider_prefab = prefab_temporal.get_node_or_null("CollisionShape2D")

	if collider_prefab:
		collider_fantasma.shape = collider_prefab.shape.duplicate()

	prefab_temporal.queue_free()


func loop_de_spawneo():
	for i in range(cantidad_a_spawnear):
		if i == (cantidad_a_spawnear - 1):
			todas_las_instancias_agotadas = true
		else:
			decidir_si_spawnear_prefab()


func conseguir_vector_aleatorio(p1: Vector2, p2: Vector2) -> Vector2:
	var x = randf_range(p1.x, p2.x)
	var y = randf_range(p1.y, p2.y)
	return Vector2(x, y)


func decidir_si_spawnear_prefab():
	var prefab_instancia = prefab.instantiate()

	var spawn_location: Vector2 = conseguir_vector_aleatorio(
		point_1.global_position,
		point_2.global_position)

	reposicionar_objeto(spawn_location, prefab_instancia)


func reposicionar_objeto(spawn_location: Vector2, prefab_instancia):
	espacio_disponible = not await actualizar_posición_area(spawn_location)

	print(espacio_disponible)
	if espacio_disponible: # Si no hay cuerpos, la posición está libre
			spawnear(prefab_instancia, spawn_location)
			print("✅ Posición libre encontrada")

	elif not espacio_disponible: # Si hay cuerpos, la posición está ocupada
		for intentos in range(intentos_maximos):
			intentos += 1
			print("❌ Ocupado. Intentos: ", intentos)

			spawn_location = conseguir_vector_aleatorio(
				point_1.global_position,
				point_2.global_position)

			espacio_disponible = await actualizar_posición_area(spawn_location)


func actualizar_posición_area(spawn_location: Vector2) -> bool:
	area_fantasma.global_position = spawn_location
	area_fantasma.force_update_transform()

	await get_tree().process_frame
	await get_tree().physics_frame

	var cuerpos: bool = area_fantasma.has_overlapping_bodies()
	return cuerpos


func spawnear(prefab_instancia: Node2D, spawn_location: Vector2):
	if espacio_disponible:
		get_tree().get_first_node_in_group("EntidadesBasuras").add_child(prefab_instancia)
		prefab_instancia.global_position = spawn_location
		objetos_spawneados.append(prefab_instancia)
		print("✅ Spawn exitoso en ", spawn_location)
