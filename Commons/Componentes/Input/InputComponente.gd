@icon("res://addons/iconos/Input.svg")
class_name InputComponente extends Node
## Componente que se encarga de las interaciones del jugador

var mov: Vector2 = Vector2.ZERO


func input_movimiento() -> Vector2:
	var mov_x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	var mov_y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	mov = Vector2(mov_x, mov_y)

	return mov


func input_recoger_basura_automatica() -> bool:
	var presionado: bool
	if Input.is_action_just_pressed("Interaccion"):
		presionado = true
		SignalBus.recoger_basura_automatica.emit()
		SignalBus.interaccion.emit()
		#print("E")
		return presionado
	else:
		return false
