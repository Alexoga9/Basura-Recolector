extends SceneTree

var errores: int = 0


func _initialize() -> void:
	validar.call_deferred()


func comprobar(condicion: bool, mensaje: String) -> void:
	if not condicion:
		errores += 1
		push_error(mensaje)


func hover(boton: Button) -> void:
	var movimiento := InputEventMouseMotion.new()
	movimiento.position = boton.get_global_rect().get_center()
	movimiento.global_position = movimiento.position
	root.push_input(movimiento, true)
	await process_frame
	await process_frame


func validar() -> void:
	var gestor = root.get_node("Interfaces")
	var pausa = load("res://UI/HUD/Pausa/pausa.tscn").instantiate()
	root.add_child(pausa)
	gestor.abrir_interfaz(pausa)
	paused = true
	await process_frame
	await process_frame
	root.notify_mouse_entered()
	var continuar: Button = pausa.continuar
	var menu: Button = continuar.get_parent().get_node("menu principal")
	comprobar(root.gui_get_focus_owner() == continuar, "Falta foco inicial en Continuar")
	comprobar(not continuar.get_global_rect().intersects(menu.get_global_rect()), "Los botones se superponen")
	comprobar(continuar.size.y < 40 and menu.size.y < 40, "El outline ocupa un boton demasiado alto")
	await hover(menu)
	comprobar(root.gui_get_focus_owner() == menu, "El hover no mueve el foco a Menu principal mientras esta pausado")
	await hover(continuar)
	comprobar(root.gui_get_focus_owner() == continuar, "El hover no devuelve el foco a Continuar")
	var abajo := InputEventKey.new()
	abajo.keycode = KEY_DOWN
	abajo.physical_keycode = KEY_DOWN
	abajo.pressed = true
	root.push_input(abajo)
	await process_frame
	comprobar(root.gui_get_focus_owner() == menu, "La flecha abajo dejo de mover el foco")
	abajo.pressed = false
	root.push_input(abajo)
	await hover(menu)
	await hover(continuar)
	comprobar(root.gui_get_focus_owner() == continuar, "El mouse no recupera el foco despues de usar teclado")
	menu.disabled = true
	await hover(menu)
	comprobar(root.gui_get_focus_owner() == continuar, "Un boton deshabilitado recibe foco con hover")
	menu.disabled = false
	gestor.cerrar_interfaz()
	gestor.abrir_interfaz(pausa)
	await process_frame
	await process_frame
	comprobar(menu.mouse_entered.get_connections().size() == 1, "Reabrir conecta el hover varias veces")
	gestor.cerrar_interfaz()
	paused = false
	pausa.queue_free()
	await process_frame
	print("Validacion foco pausa: %d errores" % errores)
	quit(0 if errores == 0 else 1)
