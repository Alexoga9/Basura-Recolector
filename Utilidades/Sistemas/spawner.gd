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
		print(i)
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

	reposicionar_objeto(spawn_location)
	spawnear(prefab_instancia, spawn_location)


func reposicionar_objeto(spawn_location: Vector2):
# Movemos el área fantasma a la posición candidata
	#while intentos < intentos_maximos and not todas_las_instancias_agotadas:
		#area_fantasma.global_position = spawn_location
		#area_fantasma.force_update_transform()
		#await get_tree().physics_frame # Espera a que las físicas se actualicen

		var cuerpos = area_fantasma.get_overlapping_bodies()

		if cuerpos.size() == 0: # No hay nadie, está libre
			espacio_disponible = true
			print("BODIES" + str(cuerpos.size()))
			#break

		else:
			intentos += 1
			print("❌ cambiando posicion")
			spawn_location = conseguir_vector_aleatorio(
			point_1.global_position,
			point_2.global_position)


func spawnear(prefab_instancia: Node2D, spawn_location: Vector2):
	if espacio_disponible:
		get_tree().get_first_node_in_group("EntidadesBasuras").add_child(prefab_instancia)
		prefab_instancia.global_position = spawn_location
		objetos_spawneados.append(prefab_instancia)
		print("✅ Spawn exitoso en ", spawn_location)


#func _on_area_fantasma_body_entered(body):
	#espacio_disponible = false
