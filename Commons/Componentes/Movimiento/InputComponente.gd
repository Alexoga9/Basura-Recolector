@icon("res://addons/iconos/Input.svg")
class_name InputComponente extends Node

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
		print("E")
		return presionado
	else:
		return false
		
	
	


func input_ataque():
	if Input.get_action_strength("Ulti"):
		pass

	if Input.get_action_strength("Ataque secundario"):
		pass

	if Input.get_action_strength("Alternar modo de movimiento"):
		pass
