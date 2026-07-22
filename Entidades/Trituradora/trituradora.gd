extends StaticBody2D

@onready var audio = %audio


func recibir_basura_jugador():
	#print("jugador")

	if Inventario.get_count("Basura") > 0:
		var cantidad_basura: int = Inventario.get_count("Basura")
		var valor_basura: int = Inventario.get_item_resource("Basura").valor
		var valor_de_venta: int = cantidad_basura*valor_basura
		Dinero.ganar(valor_de_venta)
		#print(str(Dinero.dinero))
		Inventario.remove_item("Basura", cantidad_basura)
		audio.play()


func recibir_basura_fisica():
	pass


func _on_trigger_basura_body_entered(body):
	#print("Area")
	if body.is_in_group("Jugador"):
		recibir_basura_jugador()
		pass
		# inventario.backpack[basura](0)

	if body.is_in_group("Basura"):
		Dinero.ganar(body.valor)
		body.collect()
		audio.play()
