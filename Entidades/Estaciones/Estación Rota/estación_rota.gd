extends StaticBody2D

# Enum
# Array de materiales y cantidades necesarias
@export var estacion: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reparar_estacion():
	sustituir_por_estación()


func sustituir_por_estación():
	var nueva_instancia = estacion.instantiate()
	nueva_instancia.global_position = global_position
	get_tree().get_first_node_in_group("Estaciones").add_child(nueva_instancia)
