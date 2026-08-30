class_name EstacionRota extends StaticBody2D

@export var estacion: PackedScene
@export var materiales: Array[MaterialesNecesarios]
var jugador_en_area: bool


func _ready():
	SignalBus.interaccion.connect(interaccion)


## Al precionar E, recibe la señal
func interaccion():
	if jugador_en_area:
		for i in materiales.size():
			matchear_enum(i)

		comprobar_materiales_restantes()


## Intenta emparejarse con el material especifico 
func matchear_enum(posicion_array: int):
	var material: MaterialesNecesarios
	match materiales[posicion_array].tipo_de_elemento:
		material.Tipo_de_Material.MADERA:
			comprar_reparacion("madera", posicion_array)

		material.Tipo_de_Material.PIEDRA:
			comprar_reparacion("piedra", posicion_array)

		material.Tipo_de_Material.ORO:
			comprar_reparacion("oro", posicion_array)

		material.Tipo_de_Material.HIERRO:
			comprar_reparacion("hierro", posicion_array)


## Busca reducir a 0 los requisitos necesarios para la reparacion
func comprar_reparacion(ID:String, posicion_array:int):
	print("Comprando... " + ID)
	var costo_materiales = materiales[posicion_array].cantidad_necesaria
	print("Tienes en el inventario " + str(Inventario.get_count(ID)) + " de " + ID)

	if Inventario.get_count(ID) >= costo_materiales and costo_materiales != 0:
		Inventario.remove_item(ID, costo_materiales)
		materiales[posicion_array].cantidad_necesaria = 0
		print("Compra exitosa de " + ID)
	elif costo_materiales == 0:
		print("ya compraste " + ID)
	else:
		print("Necesitas "+ str(costo_materiales) + " de " +ID)


## revisa si se cumplen las condiciones para reparar
func comprobar_materiales_restantes():
	var comprados: int
	for i in materiales.size():
		print(materiales[i].cantidad_necesaria)
		if materiales[i].cantidad_necesaria == 0:
			comprados += 1
			print("Se completo la compra de " + str(comprados))
			SignalBus.actualizar_estacion_rota.emit()

	if comprados == materiales.size():
		print("Ya todo comprado, toma tu estacion")
		sustituir_por_estación()
	else:
		print("We, te faltan vainas :v, te falta " + str(comprados))


## Cambia la instancia de rota por una funcional
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
