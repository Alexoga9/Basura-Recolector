extends ResaltadoComponente

@onready var basura: Basura =$"../.."


func _ready():

	# Ahora conectamos correctamente
	trigger_area.area_entered.connect(_on_area_2d_area_entered)
	trigger_area.area_exited.connect(_on_area_2d_area_exited)


#func _on_trigger_jugador_body_entered(body):
	#if body.is_in_group("Radar Basura"):
		#resaltado()
#
#
#func _on_trigger_jugador_body_exited(body):
	#if body.is_in_group("Radar Basura"):
		#no_resaltado()


func _on_area_2d_mouse_entered():
	print("MOUSE")
	if basura.en_area_jugador:
		resaltado()


func _on_area_2d_mouse_exited():
	no_resaltado()


func _on_area_2d_area_entered(area):
	print("Caja")
	resaltado()


func _on_area_2d_area_exited(area):
	if area.is_in_group("Radar Basura"):
		no_resaltado()
