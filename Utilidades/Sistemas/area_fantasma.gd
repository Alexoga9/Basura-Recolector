extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("toque otra colision")
		#get_parent().queue_free()


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("toque shape")


func _on_area_entered(area):
	print("toque area")
