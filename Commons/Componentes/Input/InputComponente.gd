@icon("res://addons/iconos/Input.svg")
class_name InputComponente extends Node
## Componente que se encarga de las interaciones del jugador

var mov: Vector2 = Vector2.ZERO


func _process(delta):
	input_tab()
	input_interaccion_E()


func input_movimiento() -> Vector2:
	var mov_x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	var mov_y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	mov = Vector2(mov_x, mov_y)
	return mov


func input_interaccion_E():
	if Input.is_action_just_pressed("Interaccion"):
		SignalBus.interaccion.emit()


func input_tab():
	if Input.is_action_just_pressed("Tab"):
		SignalBus.input_tab.emit()
