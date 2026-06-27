extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func recibir_basura_jugador(objeto:Node2D):
	if objeto.is_in_group("Jugador"):
		print("jugador")


func recibir_basura_fisica():
	pass


func _on_trigger_basura_area_entered(area):
	if area.is_in_group("Jugador"):
		print("jugador")
