extends Node2D

@export var cantidad_a_spawnear: int

@export var point_1: Marker2D
@export var point_2: Marker2D

@export var prefab: PackedScene


func _ready():
	randomize() #this function ensures every playthrough is different
	loop_de_spawneo()


func get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
#region Part 2a: Getting Random x-values and y-values
	var x_value: float = randf_range(p1.x, p2.x)
	var y_value: float = randf_range(p1.y, p2.y)
#endregion

# Putting Together the Point
	var random_point_inside: Vector2 = Vector2(x_value, y_value)

	return(random_point_inside)


func spawn_prefab():

	var prefab_instancia: Node = prefab.instantiate()

	add_child(prefab_instancia)

	#Uses our function to generate a random spawn location
	var spawn_location: Vector2 = get_random_point_inside(point_1.global_position, point_2.global_position)
	#Sets the position to the random spawn location
	prefab_instancia.set_position(spawn_location)


func loop_de_spawneo():
	for i in cantidad_a_spawnear:
		spawn_prefab()
		print("Spawn")
