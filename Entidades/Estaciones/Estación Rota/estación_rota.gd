extends StaticBody2D

# Enum
# Array de materiales y cantidades necesarias
@export var estacion: PackedScene
@export var materiales: Array[MaterialesNecesarios]


# Called when the node enters the scene tree for the first time.
func _ready():
	matchear_enum(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func reparar_estacion():
	#


func comprar_reparacion(ID:String, posicion_array:int):
	var costo_materiales = materiales[posicion_array].cantidad_necesaria

	if Inventario.get_count(ID) >= costo_materiales:
		Inventario.remove_item(ID, costo_materiales)
		print("Compra exitosa")
	else:
		print("Te falta "+ ID)


func matchear_enum(posicion_array: int):
	var material: MaterialesNecesarios
	match materiales[posicion_array].tipo_de_elemento:
		material.Tipo_de_Material.MADERA:
			print("MADERA")
			comprar_reparacion("Madera", posicion_array)

		material.Tipo_de_Material.PIEDRA:
			print("PIEDRA")

		material.Tipo_de_Material.ORO:
			print("ORO")

		material.Tipo_de_Material.HIERRO:
			print("HIERRO")


func sustituir_por_estación():
	var nueva_instancia = estacion.instantiate()
	nueva_instancia.global_position = global_position
	get_tree().get_first_node_in_group("Estaciones").add_child(nueva_instancia)
