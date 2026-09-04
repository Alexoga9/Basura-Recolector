extends StaticBody2D

var interaccion_del_jugador: bool = false
var jugador_en_area: bool = false


func _ready():
	SignalBus.interaccion.connect(interaccion_recibida)


func _process(delta):
	mostrar_ocultar_tienda()


func interaccion_recibida():
	interaccion_del_jugador = !interaccion_del_jugador


func mostrar_ocultar_tienda():
	if interaccion_del_jugador and jugador_en_area:
		SignalBus.mostrar_tienda.emit()
	else:
		SignalBus.ocultar_tienda.emit()


func _on_trigger_jugador_body_entered(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = true


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = false
		interaccion_del_jugador = false
