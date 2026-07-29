extends StaticBody2D

@onready var audio = %audio
@onready var sierras = %Sierras


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
		sierras.play()


func recibir_basura_fisica(body):
	Dinero.ganar(body.valor)
	body.collect()
	audio.play()
	sierras.play()


func _on_trigger_basura_body_entered(body):
	#print("Area")
	if body.is_in_group("Jugador") and Inventario.get_count("Basura") > 0:
		recibir_basura_jugador()

	if body.is_in_group("Basura"):
		recibir_basura_fisica(body)
