extends Node2D

@export var cantidad_a_spawnear: int

@export var point_1: Marker2D
@export var point_2: Marker2D

@export var prefab: PackedScene

# 📌 1. El área fantasma (debe estar en la escena como hijo)
@onready var area_fantasma: Area2D = %AreaFantasma
@onready var collider_fantasma: CollisionShape2D = %ColisionFantasma

# 📌 2. Lista para guardar los objetos ya spawneados (para futuras comprobaciones)
var objetos_spawneados: Array = []

# 📌 3. Configuración del límite
var intentos_maximos: int = 30 # Ajusta este número a tu gusto


func _ready():
	randomize()

	# 📌 4. Copiamos la forma del collider del prefab al fantasma
	# Esto asegura que el área fantasma tenga el mismo tamaño que el objeto real
	var prefab_temp = prefab.instantiate()
	var collider_prefab = prefab_temp.get_node_or_null("CollisionShape2D")

	if collider_prefab:
		collider_fantasma.shape = collider_prefab.shape.duplicate()

	prefab_temp.queue_free()

	loop_de_spawneo()


func get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	var x = randf_range(p1.x, p2.x)
	var y = randf_range(p1.y, p2.y)
	return Vector2(x, y)


func loop_de_spawneo():
	for i in range(cantidad_a_spawnear):
		spawn_prefab()


func spawn_prefab():
	var prefab_instancia = prefab.instantiate()

	# 📌 5. Generamos una posición aleatoria
	var spawn_location: Vector2 = get_random_point_inside(point_1.global_position, point_2.global_position)

	# 📌 6. Intentamos encontrar una posición libre (con límite de intentos)
	var intentos: int = 0
	var espacio_disponible: bool = false

	while intentos < intentos_maximos and not espacio_disponible:
		# Movemos el área fantasma a la posición candidata
		area_fantasma.global_position = spawn_location
		await get_tree().physics_frame # Espera a que las físicas se actualicen

		var cuerpos_solapados = area_fantasma.has_overlapping_bodies()
		# Si no hay nada, ¡posición libre!
		if !cuerpos_solapados:
			espacio_disponible = true
		else:
			espacio_disponible = false
			#break

		# Si está ocupada, generamos otra posición y aumentamos el contador
		spawn_location = get_random_point_inside(point_1.global_position, point_2.global_position)
		intentos += 1

	# 📌 7. Resultado final
	if espacio_disponible:
		# 🔥 Posición válida encontrada: spawneamos
		add_child(prefab_instancia)
		prefab_instancia.global_position = spawn_location
		objetos_spawneados.append(prefab_instancia)
		print("✅ Spawn exitoso en ", spawn_location)
	else:
		# 🛑 No se encontró posición después de N intentos: ABORTAMOS
		prefab_instancia.queue_free()
		print("❌ Spawn abortado (no hay espacio libre después de ", intentos_maximos, " intentos)")
