extends Node2D

@export var cantidad_a_spawnear: int = 10
@export var point_1: Marker2D
@export var point_2: Marker2D
@export var prefab: PackedScene
@export var distancia_minima_extra: float = 10.0 # Margen adicional de seguridad

var objetos_spawneados: Array = []
var intentos_maximos: int = 100 # Más intentos para mejor probabilidad
var radio_deteccion: float = 0.0
var area_spawn_rect: Rect2

@onready var area_fantasma: Area2D = %AreaFantasma
@onready var collider_fantasma: CollisionShape2D = %ColisionFantasma


func _ready():
	calcular_radio_deteccion()
	calcular_area_spawn()
	loop_de_spawneo()


func calcular_radio_deteccion():
	# Obtener el radio del collision shape del prefab
	var prefab_temporal = prefab.instantiate()
	var collider = prefab_temporal.get_node_or_null("CollisionShape2D")

	if collider and collider.shape:
		var shape = collider.shape

		# Obtener el radio/ tamaño del collider
		if shape is CircleShape2D:
			radio_deteccion = shape.radius + distancia_minima_extra
		elif shape is RectangleShape2D:
			# Para rectángulos usamos la diagonal/2 como radio aproximado
			var size = shape.extents * 2
			radio_deteccion = size.length() / 2 + distancia_minima_extra
		elif shape is CapsuleShape2D:
			radio_deteccion = shape.radius + shape.height / 2 + distancia_minima_extra
		else:
			# Valor por defecto si no se puede determinar
			radio_deteccion = 20.0 + distancia_minima_extra

		print("Radio de detección calculado: ", radio_deteccion)

	prefab_temporal.queue_free()


func calcular_area_spawn():
	# Definir el área de spawn basada en los dos puntos
	var min_x = min(point_1.global_position.x, point_2.global_position.x)
	var max_x = max(point_1.global_position.x, point_2.global_position.x)
	var min_y = min(point_1.global_position.y, point_2.global_position.y)
	var max_y = max(point_1.global_position.y, point_2.global_position.y)

	area_spawn_rect = Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
	print("Área de spawn definida: ", area_spawn_rect)


func loop_de_spawneo():
	randomize()
	var objetos_creados = 0

	while objetos_creados < cantidad_a_spawnear:
		var posicion_valida = await buscar_posicion_valida()

		if posicion_valida != Vector2.ZERO:
			spawnear(posicion_valida)
			objetos_creados += 1
			print("Spawn exitoso en: ", posicion_valida)
			print("Progreso: ", objetos_creados, "/", cantidad_a_spawnear)
		else:
			print("❌ No se pudo encontrar posición válida después de ", intentos_maximos, " intentos")
			break


func buscar_posicion_valida() -> Vector2:
	for intento in range(intentos_maximos):
		# Generar posición aleatoria dentro del área
		var posicion_aleatoria = Vector2(
			randf_range(area_spawn_rect.position.x, area_spawn_rect.position.x + area_spawn_rect.size.x),
			randf_range(area_spawn_rect.position.y, area_spawn_rect.position.y + area_spawn_rect.size.y)

		)

		# Verificar si la posición es válida (no hay objetos cercanos)
		if await es_posicion_valida(posicion_aleatoria):
			return posicion_aleatoria

		# Opcional: mostrar progreso cada 10 intentos
		if intento % 10 == 0:
			print("Buscando posición... Intento ", intento + 1)

	return Vector2.ZERO


func es_posicion_valida(posicion: Vector2) -> bool:
	# Revisar contra objetos ya spawneados
	for objeto in objetos_spawneados:
		if objeto and is_instance_valid(objeto):
			var distancia = posicion.distance_to(objeto.global_position)

			if distancia < radio_deteccion:
				return false # Posición ocupada

	# También podemos usar el Area2D como verificación adicional
	return not await esta_posicion_ocupada_por_area(posicion)


func esta_posicion_ocupada_por_area(posicion: Vector2) -> bool:
	# Mover el área fantasma a la posición y verificar colisiones
	area_fantasma.global_position = posicion
	area_fantasma.force_update_transform()

	# Esperar un frame para que se actualice la física
	await get_tree().physics_frame

	var cuerpos = area_fantasma.get_overlapping_bodies()
	return cuerpos.size() > 0


func spawnear(posicion: Vector2):
	var nueva_instancia = prefab.instantiate()

	# Agregar al grupo de entidades
	get_tree().get_first_node_in_group("EntidadesBasuras").add_child(nueva_instancia)
	nueva_instancia.global_position = posicion

	# Agregar al array de objetos spawneados
	objetos_spawneados.append(nueva_instancia)

	# Opcional: conectar señal cuando el objeto sea eliminado
	if nueva_instancia.has_signal("tree_exited"):
		nueva_instancia.tree_exited.connect(func():
			objetos_spawneados.erase(nueva_instancia)

		)


# Función de utilidad: obtener la lista de posiciones ocupadas
func obtener_posiciones_ocupadas() -> Array:
	var posiciones = []

	for objeto in objetos_spawneados:
		if objeto and is_instance_valid(objeto):
			posiciones.append(objeto.global_position)

	return posiciones


# Función de debug para visualizar las áreas ocupadas
func _draw():
	if Engine.is_editor_hint() or OS.is_debug_build():
		# Dibujar el área de spawn
		draw_rect(area_spawn_rect, Color.YELLOW, false, 2.0)

		# Dibujar círculos alrededor de los objetos spawneados
		for objeto in objetos_spawneados:
			if objeto and is_instance_valid(objeto):
				draw_circle(objeto.global_position, radio_deteccion, Color.RED, false, 2.0)
