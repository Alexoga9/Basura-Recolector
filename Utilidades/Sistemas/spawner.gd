extends Node2D

@export var point_1: Marker2D
@export var point_2: Marker2D

@export var prefab: PackedScene


func _ready():
	randomize() #this function ensures every playthrough is different


func _process(_delta):
	#Every time we press the left mouse button, we spawn a powerup.
	if Input.is_action_just_pressed("Click"):
		spawn_prefab()


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
