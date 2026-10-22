extends SceneTree

func _initialize() -> void:
	validar.call_deferred()

func validar() -> void:
	var mundo := Node2D.new()
	root.add_child(mundo)
	current_scene = mundo
	var jugador = load("res://Entidades/Jugador/Jugador.tscn").instantiate()
	mundo.add_child(jugador)
	jugador.set_physics_process(false)
	var caja := StaticBody2D.new()
	caja.collision_layer = 4
	caja.position = Vector2(-1, 20)
	var forma := CollisionShape2D.new()
	forma.shape = load("res://Entidades/Basura/Caja/caja_shape_2d.tres")
	caja.add_child(forma)
	mundo.add_child(caja)
	await physics_frame
	var errores := 0
	for desplazamiento in [Vector2.ZERO, Vector2(0.25, 0.5), Vector2(103.5, -27.25)]:
		caja.position = Vector2(-1, 20) + desplazamiento
		await physics_frame
		for direccion in [Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]:
			jugador.position = caja.position - direccion * 20
			jugador.velocity = Vector2.ZERO
			var minimo := Vector2(INF, INF)
			var maximo := Vector2(-INF, -INF)
			for paso in 120:
				await physics_frame
				jugador.movimiento_componente.movimiento(direccion, 1.0 / 60.0)
				if paso >= 60:
					minimo = minimo.min(jugador.position)
					maximo = maximo.max(jugador.position)
			var oscilacion := maximo.distance_to(minimo)
			print("Contacto ", direccion, " caja=", caja.position, " oscilacion=", oscilacion)
			if oscilacion > 0.0001 or not jugador.get_slide_collision_count():
				errores += 1
			var contacto: Vector2 = jugador.position
			for paso in 15:
				await physics_frame
				jugador.movimiento_componente.movimiento(-direccion, 1.0 / 60.0)
			if (jugador.position - contacto).dot(-direccion) < 10.0:
				errores += 1
	print("Validacion colisiones: ", errores, " errores")
	quit(1 if errores else 0)
