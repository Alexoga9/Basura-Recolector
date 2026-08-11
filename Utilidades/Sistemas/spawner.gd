extends Node2D

@export var cantidad_a_spawnear: int

@export var point_1: Marker2D
@export var point_2: Marker2D

@export var prefab: PackedScene

@onready var area_fantasma: Area2D = %AreaFantasma
@onready var collider_fantasma: CollisionShape2D = %ColisionFantasma

var objetos_spawneados: Array = []

# 📌 3. Configuración del límite
var intentos_maximos: int = 30 # Ajusta este número a tu gusto
var espacio_disponible: bool = false


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


func conseguir_vector_aleatorio(p1: Vector2, p2: Vector2) -> Vector2:
	var x = randf_range(p1.x, p2.x)
	var y = randf_range(p1.y, p2.y)
	return Vector2(x, y)


func loop_de_spawneo():
	for i in range(cantidad_a_spawnear):
		spawn_prefab()


func spawn_prefab():
	var prefab_instancia = prefab.instantiate()

	# 📌 5. Generamos una posición aleatoria
	var spawn_location: Vector2 = conseguir_vector_aleatorio(
		point_1.global_position,
		point_2.global_position)

	# 📌 6. Intentamos encontrar una posición libre (con límite de intentos)
	var intentos: int = 0

	reposicionar_objeto(intentos, spawn_location)
	nacer_o_abortar(intentos, prefab_instancia, spawn_location)


func reposicionar_objeto(intentos: int, spawn_location: Vector2):
	var cuerpos_solapados = area_fantasma.has_overlapping_bodies()

	while intentos < intentos_maximos and not espacio_disponible:
		# Movemos el área fantasma a la posición candidata
		area_fantasma.global_position = spawn_location
		area_fantasma.force_update_transform()
		await get_tree().physics_frame # Espera a que las físicas se actualicen

		if !cuerpos_solapados: # Si no hay nada, ¡posición libre!
			espacio_disponible = true
			print("espacio libre")

		else: # Si está ocupada, generamos otra posición y aumentamos el contador
			espacio_disponible = false
			print("Cuerpos detectados en ", spawn_location, ": ", area_fantasma.get_overlapping_bodies().size())
			spawn_location = conseguir_vector_aleatorio(point_1.global_position, point_2.global_position)
			intentos += 1
			#break


func nacer_o_abortar(intentos: int, prefab_instancia: Node2D, spawn_location: Vector2):
		# 📌 7. Resultado final

	if espacio_disponible: # 🔥 Posición válida encontrada: spawneamos
		add_child(prefab_instancia)
		prefab_instancia.global_position = spawn_location
		objetos_spawneados.append(prefab_instancia)
		print("✅ Spawn exitoso en ", spawn_location)
	else:
		# 🛑 No se encontró posición después de N intentos: ABORTAMOS
		prefab_instancia.queue_free()
		print("❌ Spawn abortado (no hay espacio libre después de ", intentos, " intentos)")
