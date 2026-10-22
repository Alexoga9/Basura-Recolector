extends SceneTree

var errores := 0

func comprobar(valor: bool, texto: String) -> void:
	if not valor:
		errores += 1
		push_error(texto)

func _initialize() -> void:
	validar.call_deferred()

func validar() -> void:
	var jugador = load("res://Entidades/Jugador/Jugador.tscn").instantiate()
	root.add_child(jugador)
	var loot = load("res://Entidades/Loot/Loot.tscn").instantiate()
	loot.data = load("res://Entidades/Loot/coleccionables/vhs.tres")
	root.add_child(loot)
	await physics_frame
	await physics_frame
	await process_frame
	var inventario = root.get_node("Inventario")
	comprobar(inventario.get_count("vhs") == 0 and not loot.recogido, "Se recogio al pasar encima")
	var clic := InputEventMouseButton.new()
	clic.button_index = MOUSE_BUTTON_LEFT
	clic.pressed = true
	loot._on_input_event(root, clic, 0)
	comprobar(inventario.get_count("vhs") == 1 and loot.recogido, "El clic cercano no recoge")
	loot._on_input_event(root, clic, 0)
	comprobar(inventario.get_count("vhs") == 1, "Recogida duplicada")
	var mensaje: Label = jugador.get_child(jugador.get_child_count() - 1)
	comprobar(mensaje.text == "Recogiste: vhs" and mensaje.position.y < -20, "Falta mensaje sobre el jugador")
	var lejano = load("res://Entidades/Loot/Loot.tscn").instantiate()
	lejano.data = load("res://Entidades/Loot/coleccionables/radio.tres")
	lejano.position = Vector2(1000, 1000)
	root.add_child(lejano)
	lejano._on_input_event(root, clic, 0)
	comprobar(not lejano.recogido, "Se recoge fuera de alcance")
	await create_timer(1.8).timeout
	comprobar(not is_instance_valid(mensaje), "El mensaje no desaparece")
	print("Validacion coleccionables: ", errores, " errores")
	quit(1 if errores else 0)
