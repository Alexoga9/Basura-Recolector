extends Node2D

#region Random Position Part 1: Defining Two Points
@export var point_1: Marker2D
@export var point_2: Marker2D
#endregion

#region Spawning Objects Part 1: Saving the Object Blueprint
@export var prefab: PackedScene
#endregion


#region Random Position Part 2: Writing a Function
func get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
#region Part 2a: Getting Random x-values and y-values
	var x_value: float = randf_range(p1.x, p2.x)
	var y_value: float = randf_range(p1.y, p2.y)
#endregion

#region Part 2b: Putting Together the Point
	var random_point_inside: Vector2 = Vector2(x_value, y_value)
#endregion

#region Part 2c: Returning the Point
	return(random_point_inside)
#endregion

#endregion


#region Spawning Objects Part 2: Writing a Function
func spawn_powerup():
#region Part 2a: Build and Place the Powerup
	#builds the powerup behind the scenes
	var powerup_instance: Node = prefab.instantiate()
	#places the powerup in our scene tree so we can see it
	add_child(powerup_instance)
#endregion
#region Part 2b: Setting the Position
	#Uses our function to generate a random spawn location
	var spawn_location: Vector2 = get_random_point_inside(point_1.global_position, point_2.global_position)
	#Sets the position to the random spawn location
	powerup_instance.set_position(spawn_location)
#endregion
#endregion


func _ready():
	randomize() #this function ensures every playthrough is different


func _process(_delta):
	#Every time we press the left mouse button, we spawn a powerup.
	if Input.is_action_just_pressed("Click"):
		spawn_powerup()
