extends SceneTree
## Ejecutar con Godot --headless --path . --script res://Tools/validar_ui_mando.gd

var errores: int = 0
var aperturas_tienda: int = 0


func _initialize() -> void:
	_run.call_deferred()


func comprobar(condicion: bool, mensaje: String) -> void:
	if not condicion:
		errores += 1
		push_error(mensaje)


func _run() -> void:
	var gestor = root.get_node("Interfaces")
	var panel := Control.new()
	var primero := Button.new()
	primero.name = "Primero"
	var segundo := Button.new()
	segundo.name = "Segundo"
	panel.add_child(primero)
	panel.add_child(segundo)
	root.add_child(panel)
	panel.hide()
	gestor.abrir_interfaz(panel)
	await process_frame
	await process_frame
	comprobar(root.gui_get_focus_owner() == primero, "Falta foco inicial")
	comprobar(primero.get_node(primero.focus_neighbor_bottom) == segundo, "Orden de navegación incorrecto")
	comprobar(gestor.juego_bloqueado(), "El menú no bloquea el juego")
	var abajo := InputEventJoypadButton.new()
	abajo.button_index = JOY_BUTTON_DPAD_DOWN
	abajo.pressed = true
	root.push_input(abajo, true)
	comprobar(root.gui_get_focus_owner() == segundo, "La cruceta no navega al siguiente botón")
	abajo.pressed = false
	root.push_input(abajo, true)
	segundo.grab_focus()
	gestor.cerrar_interfaz()
	gestor.abrir_interfaz(panel)
	await process_frame
	await process_frame
	comprobar(root.gui_get_focus_owner() == segundo, "No recuerda la selección")
	segundo.disabled = true
	await process_frame
	await process_frame
	comprobar(root.gui_get_focus_owner() == primero, "No recupera foco al deshabilitar una compra")
	var hud = load("res://UI/HUD/hud.tscn").instantiate()
	root.add_child(hud)
	var pausa := InputEventJoypadButton.new()
	pausa.button_index = JOY_BUTTON_START
	pausa.pressed = true
	hud._input(pausa)
	comprobar(paused and hud.panel_pausa.visible and not panel.visible, "Start no reemplaza el panel por pausa")
	hud._input(pausa)
	comprobar(not paused and not hud.panel_pausa.visible, "Start no cierra pausa")
	hud._input(pausa)
	var volver := InputEventJoypadButton.new()
	volver.button_index = JOY_BUTTON_B
	volver.pressed = true
	hud._input(volver)
	comprobar(not paused and not hud.panel_pausa.visible, "B no cierra pausa")
	var escape := InputEventKey.new()
	escape.physical_keycode = KEY_ESCAPE
	escape.pressed = true
	hud._input(escape)
	comprobar(paused, "Esc no abre pausa")
	hud._input(escape)
	comprobar(not paused, "Esc no cierra pausa")
	await process_frame
	await process_frame
	comprobar(not gestor.juego_bloqueado(), "El bloqueo permanece al cerrar")
	var estacion = load("res://Entidades/Estaciones/Tienda/tienda.gd").new()
	root.add_child(estacion)
	estacion.jugador_en_area = true
	root.get_node("SignalBus").mostrar_tienda.connect(func(): aperturas_tienda += 1)
	estacion.interaccion_recibida()
	await process_frame
	await process_frame
	comprobar(aperturas_tienda == 1, "La tienda emite aperturas repetidas")
	estacion.queue_free()
	panel.queue_free()
	hud.queue_free()
	print("Validación UI mando: %d errores" % errores)
	quit(0 if errores == 0 else 1)
