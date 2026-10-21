extends SceneTree

var errores: int = 0


func _initialize() -> void:
	validar.call_deferred()


func comprobar(condicion: bool, mensaje: String) -> void:
	if not condicion:
		errores += 1
		push_error(mensaje)


func pulsar_e() -> void:
	var evento := InputEventKey.new()
	evento.keycode = KEY_E
	evento.physical_keycode = KEY_E
	evento.pressed = true
	Input.parse_input_event(evento)
	await process_frame
	await process_frame
	evento = InputEventKey.new()
	evento.keycode = KEY_E
	evento.physical_keycode = KEY_E
	Input.parse_input_event(evento)
	await process_frame


func validar() -> void:
	var mundo := Node2D.new()
	root.add_child(mundo)
	current_scene = mundo
	var loots := Node2D.new()
	loots.add_to_group("EntidadesLoot")
	mundo.add_child(loots)
	var niveles = root.get_node("NivelesDeExperiencia")
	niveles.reset()
	var jugador = load("res://Entidades/Jugador/Jugador.tscn").instantiate()
	mundo.add_child(jugador)
	jugador.canMove = false
	var inventario = root.get_node("Inventario")
	inventario.peso_maximo = 100
	var escena = load("res://Entidades/Basura/Basura.tscn")
	var datos = load("res://Entidades/Basura/Caja/Obstaculos/Arbol/Arbol Cesped Claro.tres")
	var arbol = escena.instantiate()
	arbol.data = datos
	arbol.position = Vector2(400, 200)
	mundo.add_child(arbol)
	var segundo = escena.instantiate()
	segundo.data = datos
	segundo.position = Vector2(600, 200)
	mundo.add_child(segundo)
	comprobar(arbol.collision_shape_2d.global_position.distance_to(arbol.global_position) < 6, "Collider separado del arbol")
	comprobar(not arbol.collision_shape_2d.top_level, "Collider no sigue al arbol")
	comprobar(arbol.sprite2d.get_rect().end.y + arbol.sprite2d.position.y < 10, "La copa esta centrada en el suelo")
	var material = arbol.resaltado_componente.material_outline
	var region = arbol.sprite2d.texture.region
	comprobar(material.get_shader_parameter("texture_region") == Vector4(region.position.x, region.position.y, region.size.x, region.size.y), "Outline usa otra region del atlas")
	comprobar(material != segundo.resaltado_componente.material_outline, "Los arboles comparten el material del outline")
	jugador.position = arbol.position + Vector2(0, 18)
	await physics_frame
	await physics_frame
	await pulsar_e()
	comprobar(arbol.golpes_restantes == 5, "Permite talar sin hacha suficiente")
	var tienda = load("res://UI/Tienda/tienda_ui.tscn").instantiate()
	mundo.add_child(tienda)
	await process_frame
	await process_frame
	for nodo in tienda.find_children("*", "Node", true, false):
		if nodo.get_script() == null:
			continue
		var archivo: String = nodo.get_script().resource_path.get_file()
		if archivo in ["mejora_resistencia.gd", "mejora_cooldown.gd", "mejora_rango.gd"]:
			for compra in 4:
				nodo.aplicar_mejora()
	comprobar(niveles.nivel_resistencia == 5 and niveles.nivel_cooldown == 5 and niveles.nivel_rango == 5, "Las compras no suben los niveles")
	comprobar(jugador.estadisticas_componente.hacha == 3, "Cooldown nivel 5 no concede hacha 3")
	comprobar(jugador.estadisticas_componente.pico == 3 and jugador.estadisticas_componente.azada == 3, "Pico o azada incorrectos en nivel 5")
	await physics_frame
	await physics_frame
	comprobar(jugador.radar_componente.objeto_resaltado == arbol, "El radar no resalta el arbol cercano")
	comprobar(arbol.sprite2d.material == material, "No se activa el outline del arbol")
	var golpes_esperados: int = maxi(0, 5 - jugador.estadisticas_componente.golpe)
	await pulsar_e()
	comprobar(arbol.golpes_restantes == golpes_esperados, "E no golpea el arbol con hacha suficiente")
	comprobar(segundo.golpes_restantes == 5 and datos.veces_a_golpear == 5, "Golpear un arbol modifica los demas")
	var estado: Dictionary = arbol.serializar_estado()
	var restaurado = escena.instantiate()
	restaurado.data = datos
	restaurado.restaurar_estado(estado)
	comprobar(restaurado.golpes_restantes == golpes_esperados, "No restaura el progreso de tala")
	restaurado.free()
	for golpe in 5:
		await pulsar_e()
	comprobar(arbol.recogida and inventario.peso == 1, "No termina de talar y recoger el arbol")
	comprobar(loots.get_child_count() == 2, "El arbol no genera sus dos materiales de madera")
	niveles.deserializar({"nivel_cooldown": 1})
	comprobar(jugador.estadisticas_componente.hacha == 0, "Cargar niveles no actualiza el hacha")
	niveles.deserializar({"nivel_cooldown": 5})
	comprobar(jugador.estadisticas_componente.hacha == 3, "Cargar nivel 5 no recupera el hacha")
	jugador.estadisticas_componente.actualizar_herramientas()
	comprobar(jugador.estadisticas_componente.hacha == 3, "Recalcular duplica herramientas")
	mundo.queue_free()
	await process_frame
	await process_frame
	change_scene_to_packed(load("res://Escenarios/Mundos/chunk_1.tscn"))
	await scene_changed
	var nivel = current_scene
	await process_frame
	await process_frame
	jugador = root.get_node("Global").jugador
	jugador.canMove = false
	var cantidad_arboles := 0
	var carpeta = get_first_node_in_group("EntidadesBasuras")
	for objeto in carpeta.get_children():
		if not "golpes_restantes" in objeto or not objeto.data.nombre.to_lower().contains("arbol"):
			continue
		cantidad_arboles += 1
		var nombre_arbol: String = objeto.name
		comprobar(objeto.collision_shape_2d.global_position.distance_to(objeto.global_position) < 6, "Collider incorrecto en arbol del nivel")
		jugador.global_position = objeto.global_position
		inventario.peso = 0
		jugador.energia_componente.energia = jugador.energia_componente.energia_maxima
		await create_timer(jugador.radar_componente.cooldown_tiempo + 0.05).timeout
		await physics_frame
		await physics_frame
		for intento in 7:
			if not is_instance_valid(objeto) or objeto.recogida:
				break
			await pulsar_e()
		comprobar(not is_instance_valid(objeto) or objeto.recogida, "No se puede talar con E el arbol real: " + nombre_arbol)
	comprobar(cantidad_arboles > 0, "La prueba no encontro arboles en el nivel")
	print("Arboles reales del nivel talados con E: %d" % cantidad_arboles)
	nivel.queue_free()
	await process_frame
	print("Validacion arboles y mejoras: %d errores" % errores)
	quit(0 if errores == 0 else 1)
