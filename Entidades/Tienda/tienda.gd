extends StaticBody2D

var interaccion_del_jugador: bool = false
var jugador_en_area: bool = false


func _process(delta):

	if Input.is_action_just_pressed("Interaccion"):
		interaccion_del_jugador = !interaccion_del_jugador
		print(interaccion_del_jugador)

	mostrar_ocultar_tienda()


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = true


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = false
		interaccion_del_jugador = false


func mostrar_ocultar_tienda():
	if interaccion_del_jugador and jugador_en_area:
		SignalBus.mostrar_tienda.emit()
	else:
		SignalBus.ocultar_tienda.emit()
