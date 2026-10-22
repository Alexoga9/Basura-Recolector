extends RefCounted

# El origen del cuerpo representa el punto de apoyo en el suelo para Y sorting.
static func aplicar(data: LootDefinicion, cuerpo: StaticBody2D, sprite: Sprite2D,
		colision: CollisionShape2D, area: Area2D) -> void:
	colision.top_level = false
	cuerpo.y_sort_enabled = false
	sprite.y_sort_enabled = false
	if data.perfil_mundo == LootDefinicion.PerfilMundo.CAJA:
		return

	var tamano := Vector2(12, 8)
	match data.perfil_mundo:
		LootDefinicion.PerfilMundo.ARBOL:
			tamano = Vector2(10, 6)
		LootDefinicion.PerfilMundo.PIEDRA:
			tamano = Vector2(12, 8)
		LootDefinicion.PerfilMundo.HIERBA:
			tamano = Vector2(12, 5)
	if data.forma_colision:
		colision.shape = data.forma_colision.duplicate()
	else:
		var rectangulo := RectangleShape2D.new()
		# Los arboles pequenos tambien tienen un tronco mas estrecho.
		if sprite.texture and data.perfil_mundo == LootDefinicion.PerfilMundo.ARBOL:
			tamano.x = minf(tamano.x, sprite.texture.get_width() * 0.4)
		rectangulo.size = tamano
		colision.shape = rectangulo
	colision.position = data.posicion_colision
	sprite.position = Vector2.ZERO
	if sprite.texture:
		var imagen := sprite.texture.get_image()
		var base := Vector2(sprite.texture.get_width() * 0.5, sprite.texture.get_height())
		if imagen and not imagen.is_empty():
			var visible := imagen.get_used_rect()
			if visible.has_area():
				base = Vector2(visible.get_center().x, visible.end.y)
		sprite.offset = sprite.texture.get_size() * 0.5 - base + data.desplazamiento_visual
	var detector := area.get_node("CollisionShape2D") as CollisionShape2D
	var forma_area := RectangleShape2D.new()
	forma_area.size = data.tamano_interaccion if data.tamano_interaccion != Vector2.ZERO else tamano + Vector2(4, 4)
	detector.shape = forma_area
	detector.position = data.posicion_colision
	# Los obstaculos del terreno no participan en las pilas de cajas.
	var apilable := cuerpo.get_node_or_null("ComponenteApilable")
	if apilable:
		apilable.set_process(false)
		apilable.altura_pila = 0
		apilable.caja_debajo = null
		apilable.caja_arriba = null
		cuerpo.z_index = 0
		apilable.ray_cast_abajo.enabled = false
		apilable.ray_cast_arriba.enabled = false
