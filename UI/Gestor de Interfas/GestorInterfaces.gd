extends Node

var interfaz_actual: Control = null
var ultimos_focos: Dictionary = {}
var ultimo_cambio: int = -1


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func juego_bloqueado() -> bool:
	return is_instance_valid(interfaz_actual) or ultimo_cambio == Engine.get_process_frames()


func botones_disponibles() -> Array[Control]:
	var botones: Array[Control] = []
	if not is_instance_valid(interfaz_actual):
		return botones
	for nodo in interfaz_actual.find_children("*", "BaseButton", true, false):
		if nodo.is_visible_in_tree() and not nodo.disabled and nodo.focus_mode == Control.FOCUS_ALL:
			botones.append(nodo)
	return botones


func _process(_delta: float) -> void:
	if not is_instance_valid(interfaz_actual):
		return
	var botones := botones_disponibles()
	for i in botones.size():
		var boton := botones[i]
		var anterior := botones[(i - 1 + botones.size()) % botones.size()]
		var siguiente := botones[(i + 1) % botones.size()]
		boton.focus_neighbor_top = boton.get_path_to(anterior)
		boton.focus_neighbor_bottom = boton.get_path_to(siguiente)
		boton.focus_neighbor_left = boton.get_path_to(boton)
		boton.focus_neighbor_right = boton.get_path_to(boton)
		boton.focus_previous = boton.get_path_to(anterior)
		boton.focus_next = boton.get_path_to(siguiente)
	var foco := get_viewport().gui_get_focus_owner()
	if not botones.has(foco):
		restaurar_foco()
	elif foco != null:
		ultimos_focos[interfaz_actual.get_instance_id()] = weakref(foco)


func restaurar_foco() -> void:
	var botones := botones_disponibles()
	if botones.is_empty():
		var foco := get_viewport().gui_get_focus_owner()
		if foco != null:
			foco.release_focus()
		return
	var referencia = ultimos_focos.get(interfaz_actual.get_instance_id())
	var anterior = referencia.get_ref() if referencia != null else null
	var destino: Control = anterior if botones.has(anterior) else botones[0]
	destino.grab_focus()


func abrir_interfaz(interfaz: Control) -> void:
	if not is_instance_valid(interfaz):
		return

	# Si ya está abierta, no hacer nada.
	if interfaz_actual == interfaz:
		interfaz.show()
		return

	# Cerrar la interfaz anterior.
	cerrar_interfaz()

	# Abrir la nueva interfaz.
	interfaz_actual = interfaz
	ultimo_cambio = Engine.get_process_frames()
	interfaz_actual.show()
	for boton in interfaz.find_children("*", "Button", true, false):
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color.TRANSPARENT
		estilo.border_color = Color(1.0, 0.85, 0.25)
		estilo.set_border_width_all(2)
		boton.add_theme_stylebox_override("focus", estilo)
	restaurar_foco.call_deferred()


func cerrar_interfaz() -> void:
	var anterior := interfaz_actual
	var foco := get_viewport().gui_get_focus_owner()
	if is_instance_valid(anterior) and foco != null and anterior.is_ancestor_of(foco):
		ultimos_focos[anterior.get_instance_id()] = weakref(foco)
		foco.release_focus()
	interfaz_actual = null
	ultimo_cambio = Engine.get_process_frames()
	if is_instance_valid(anterior):
		anterior.hide()


func cerrar_interfaz_especifica(interfaz: Control) -> void:
	if interfaz_actual == interfaz:
		cerrar_interfaz()
