extends StaticBody2D

@onready var audio = %audio
@onready var sierras = %Sierras
@onready var chispas = %Chispas


func recibir_basura_jugador():
	#print("jugador")

	if Inventario.get_count("Basura") > 0:
		var cantidad_basura: int = Inventario.get_count("Basura")
		var valor_basura: int = Inventario.get_item_resource("Basura").valor
		var valor_de_venta: int = cantidad_basura * valor_basura
		Dinero.ganar(valor_de_venta)
		#print(str(cantidad_basura))
		Inventario.remove_item("Basura", cantidad_basura)
		audio.play()
		sierras.play()
		chispas.play()


func recibir_basura_fisica(body):
	Dinero.ganar(body.valor)
	body.collect()
	audio.play()
	sierras.play()
	chispas.play()


func _on_trigger_basura_body_entered(body):
	#print("Area") puede que cuado este en el area del basudero presione una tecla para que sea mas interactivo
	if body.is_in_group("Jugador") and Inventario.get_count("Basura") > 0:
		recibir_basura_jugador()

	if body.is_in_group("BolsaDeBasura"):
		recibir_basura_fisica(body)


func _on_chispas_animation_finished():
	chispas.frame = 0
