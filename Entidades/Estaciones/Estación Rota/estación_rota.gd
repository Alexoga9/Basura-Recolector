extends StaticBody2D

# Enum
# Array de materiales y cantidades necesarias
@export var estacion: PackedScene
@export var materiales: Array[MaterialesNecesarios]
var jugador_en_area: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.interaccion.connect(interaccion)


#func process():
	#


func interaccion():
	if jugador_en_area:
		matchear_enum(0)
		comprobar_materiales_restantes()


func matchear_enum(posicion_array: int):
	var material: MaterialesNecesarios
	match materiales[posicion_array].tipo_de_elemento:
		material.Tipo_de_Material.MADERA:
			comprar_reparacion("Madera", posicion_array)

		material.Tipo_de_Material.PIEDRA:
			comprar_reparacion("Piedra", posicion_array)

		material.Tipo_de_Material.ORO:
			comprar_reparacion("Oro", posicion_array)

		material.Tipo_de_Material.HIERRO:
			comprar_reparacion("Hierro", posicion_array)


func comprar_reparacion(ID:String, posicion_array:int):
	print("Comprando... " + ID)
	var costo_materiales = materiales[posicion_array].cantidad_necesaria

	if Inventario.has_item(ID):
		if Inventario.get_count(ID) >= costo_materiales:
			Inventario.remove_item(ID, costo_materiales)
			print("Compra exitosa de " + ID)
		else:
			print("Necesitas "+ str(costo_materiales) + " de " +ID)
	else:
		print("no hay ni verga de " + ID)


func comprobar_materiales_restantes():
	var comprados: int
	for i in materiales.size():
		print(materiales[i].cantidad_necesaria)
		if materiales[i].cantidad_necesaria == 0:
			comprados += 1
			print("Se completo la compra de " + str(comprados))

	if comprados == materiales.size():
		print("Ya todo comprado, toma tu estacion")
		sustituir_por_estación()
	else:
		print("We, te faltan vainas :v, te falta " + str(comprados))


func sustituir_por_estación():
	var nueva_instancia = estacion.instantiate()
	var padre = get_tree().get_first_node_in_group("Estaciones")

	padre.add_child.call_deferred(nueva_instancia)
	nueva_instancia.global_position = position

	queue_free()


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = true


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = false
