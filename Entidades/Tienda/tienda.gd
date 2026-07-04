extends StaticBody2D


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		SignalBus.mostrar_tienda.emit()


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		SignalBus.ocultar_tienda.emit()
