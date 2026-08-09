extends Node2D

@export var cantidad_a_spawnear: int

@export var point_1: Marker2D
@export var point_2: Marker2D

@export var prefab: PackedScene

var objetos_spawneados: Array = []


func _ready():
	randomize() #this function ensures every playthrough is different
	loop_de_spawneo()


func get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	var x = randf_range(p1.x, p2.x)
	var y = randf_range(p1.y, p2.y)
	return Vector2(x, y)


func spawn_prefab():

	var prefab_instancia: Node = prefab.instantiate()

	add_child(prefab_instancia)

	#Uses our function to generate a random spawn location
	var spawn_location: Vector2 = get_random_point_inside(point_1.global_position, point_2.global_position)
# 🔥 3. Preguntamos: ¿Esta posición está demasiado cerca de otra ya spawneada?
	var distancia_minima = 4.5 # Ajusta este número al tamaño de tu objeto (ej: 32, 50, 64)
	var posicion_valida = true

	for objeto in objetos_spawneados:
		if objeto.global_position.distance_to(spawn_location) < distancia_minima:
			posicion_valida = false
			break

	# 🔥 4. Si la posición no es válida, buscamos otra aleatoria
	while not posicion_valida:
		spawn_location = get_random_point_inside(point_1.global_position, point_2.global_position)

		# Volvemos a revisar con la nueva posición
		posicion_valida = true

		for objeto in objetos_spawneados:
			if objeto.global_position.distance_to(spawn_location) < distancia_minima:
				posicion_valida = false
				break

	# 📌 5. Cuando encontramos una posición válida, spawneamos
	add_child(prefab_instancia)
	prefab_instancia.global_position = spawn_location

	# 📌 6. Guardamos el objeto en la lista para futuras comprobaciones
	objetos_spawneados.append(prefab_instancia)


func loop_de_spawneo():
	for i in range(cantidad_a_spawnear):
		spawn_prefab()
		print("Spawn ", i+1)
