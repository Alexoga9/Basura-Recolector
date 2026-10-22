extends SceneTree

var errores := 0
var cantidad := 0

func comprobar(valor: bool, texto: String) -> void:
	if not valor:
		errores += 1
		push_error(texto)

func _initialize() -> void:
	validar.call_deferred()

func validar() -> void:
	var mundo := Node2D.new()
	root.add_child(mundo)
	current_scene = mundo
	var recursos: Array[LootDefinicion] = []
	for ruta in [
		"res://Entidades/Basura/Caja/Obstaculos/Arbol/Arbol Cesped Claro.tres",
		"res://Entidades/Basura/Caja/Obstaculos/Arbol/Arbol Cesped Oscuro.tres",
		"res://Entidades/Basura/Caja/Obstaculos/piedra/piedra cesped claro.tres",
		"res://Entidades/Basura/Caja/Obstaculos/piedra/piedra cesped oscuro.tres",
		"res://Entidades/Basura/Caja/Obstaculos/hierba alta/hierba alta.tres",
		"res://Entidades/Basura/Obstaculo prueba.tres",
		"res://Entidades/Basura/basura_data.tres"]:
		recursos.append(load(ruta))
	for ruta in ["chunk_1", "chunk_2", "chunk_3", "Chunk_4"]:
		var escena: PackedScene = load("res://Escenarios/Mundos/" + ruta + ".tscn")
		var estado := escena.get_state()
		for nodo in estado.get_node_count():
			for propiedad in estado.get_node_property_count(nodo):
				if estado.get_node_property_name(nodo, propiedad) == &"data":
					var dato = estado.get_node_property_value(nodo, propiedad)
					if dato is LootDefinicion and dato.perfil_mundo != 0:
						recursos.append(dato)
	var prefab: PackedScene = load("res://Entidades/Basura/Basura.tscn")
	for data in recursos:
		var variantes: Array = []
		variantes.assign(data.conjunto_de_sprites)
		if variantes.is_empty():
			variantes.append(data.sprite)
		for textura: Texture2D in variantes:
			var objeto = prefab.instantiate()
			objeto.data = data
			objeto.position = Vector2(231.25, 174.5)
			mundo.add_child(objeto)
			objeto.sprite2d.texture = textura
			objeto.PRESENTACION.aplicar(data, objeto, objeto.sprite2d, objeto.collision_shape_2d, objeto.get_node("Mouse Detector"))
			await physics_frame
			await physics_frame
			cantidad += 1
			comprobar(not objeto.collision_shape_2d.top_level, "Colision separada: " + data.nombre)
			comprobar(objeto.collision_shape_2d.global_position.distance_to(objeto.global_position + objeto.collision_shape_2d.position) < 0.001, "Colision fuera de lugar")
			comprobar(not objeto.y_sort_enabled and objeto.z_index == 0, "Orden de dibujo incorrecto")
			var punto := PhysicsPointQueryParameters2D.new()
			punto.position = objeto.collision_shape_2d.global_position
			punto.collision_mask = 4
			comprobar(not mundo.get_world_2d().direct_space_state.intersect_point(punto).is_empty(), "Sin colision fisica: " + data.nombre)
			if data.perfil_mundo != 0:
				comprobar(textura != null, "Objeto invisible: " + data.nombre)
				var base := textura.get_image().get_used_rect().end.y
				var pie: float = objeto.sprite2d.get_rect().position.y + base
				comprobar(absf(pie - data.desplazamiento_visual.y) < 0.01, "Base desalineada: " + data.nombre)
				comprobar(not objeto.componente_apilable.is_processing(), "Obstaculo apilable")
				if data.perfil_mundo == LootDefinicion.PerfilMundo.ARBOL:
					punto.position = objeto.global_position + Vector2(0, -15)
					comprobar(mundo.get_world_2d().direct_space_state.intersect_point(punto).is_empty(), "La copa bloquea el paso")
			var resaltado = objeto.resaltado_componente
			resaltado.resaltado()
			comprobar(objeto.sprite2d.material == resaltado.material_outline, "Outline no aplicado")
			comprobar(resaltado.material_outline != load("res://Assets/entidades/OutlineMaterial.tres"), "Material compartido")
			if textura is AtlasTexture:
				var r: Rect2 = textura.region
				comprobar(resaltado.material_outline.get_shader_parameter("texture_region") == Vector4(r.position.x, r.position.y, r.size.x, r.size.y), "Region incorrecta")
			resaltado.no_resaltado()
			comprobar(objeto.sprite2d.material == null, "Outline no se desactiva")
			objeto.free()
	print("Validacion obstaculos: ", cantidad, " variantes, ", errores, " errores")
	mundo.free()
	quit(1 if errores else 0)
