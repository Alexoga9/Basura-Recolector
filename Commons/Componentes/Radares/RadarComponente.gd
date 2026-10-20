@icon("res://addons/iconos/Radar.svg")
class_name RadarComponente extends Area2D

# =========================================
# VARIABLES
# =========================================

var cuerpos: Array[Basura] = []
var objeto_resaltado: Basura = null

@onready var jugador: Jugador = $".."
@onready var timer: Timer = %Timer
@onready var basura_collider: CollisionShape2D = %basuraCollider

@export var cooldown_tiempo: float = 3.0

var cooldown_activo: bool = false

# =========================================
# INICIALIZACIÓN
# =========================================


func _ready() -> void:
	SignalBus.interaccion.connect(revisar_espacio_inventario)

	timer.wait_time = cooldown_tiempo
	timer.one_shot = true

	# Conectar señales del radar
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

# =========================================
# ACTUALIZACIÓN
# =========================================


func _physics_process(_delta: float) -> void:
	limpiar_cuerpos()
	actualizar_resaltado()

# =========================================
# LIMPIAR ARRAY DE CUERPOS
# =========================================


func limpiar_cuerpos() -> void:
	var cuerpos_detectados: Array[Node2D] = []

	# Obtener los cuerpos que realmente
	# siguen dentro del radar.
	for body in get_overlapping_bodies():
		if body is Basura:
			if not body.is_queued_for_deletion():
				cuerpos_detectados.append(body)

	# Recorrer el array al revés para poder
	# eliminar elementos sin alterar el recorrido.
	for i in range(cuerpos.size() - 1, -1, -1):
		var body: Basura = cuerpos[i]

		if not is_instance_valid(body):
			cuerpos.remove_at(i)
			continue

		if body.is_queued_for_deletion():
			cuerpos.remove_at(i)
			continue

		# Si ya no está dentro del radar
		if not cuerpos_detectados.has(body):

			body.en_area_jugador = false
			body.resaltado_componente.no_resaltado()

			cuerpos.remove_at(i)

	# Registrar nuevas basuras detectadas.
	for body in cuerpos_detectados:
		if not cuerpos.has(body):
			cuerpos.append(body)
			body.en_area_jugador = true

# =========================================
# BUSCAR LA BASURA MÁS CERCANA
# =========================================


func get_entidad_mas_cercana() -> Basura:
	var objeto_cercano: Basura = null
	var distancia_minima: float = INF

	for obj in cuerpos:
		if not is_instance_valid(obj):
			continue

		if obj.is_queued_for_deletion():
			continue

		var distancia: float = jugador.global_position.distance_squared_to(
			obj.global_position

		)

		if distancia < distancia_minima:
			distancia_minima = distancia
			objeto_cercano = obj

	return objeto_cercano

# =========================================
# ACTUALIZAR RESALTADO
# =========================================


func actualizar_resaltado() -> void:
	var objeto_cercano: Basura = get_entidad_mas_cercana()

	# No cambiar si sigue siendo el mismo.
	if objeto_cercano == objeto_resaltado:
		return

	# Quitar resaltado anterior.
	if is_instance_valid(objeto_resaltado):
		if not objeto_resaltado.is_queued_for_deletion():
			objeto_resaltado.resaltado_componente.no_resaltado()

	# Guardar nuevo objeto.
	objeto_resaltado = objeto_cercano

	# Resaltar el nuevo objeto más cercano.
	if is_instance_valid(objeto_resaltado):
		if not objeto_resaltado.is_queued_for_deletion():
			objeto_resaltado.resaltado_componente.resaltado()

# =========================================
# COMPROBAR ESPACIO DEL INVENTARIO
# =========================================


func revisar_espacio_inventario(body = null) -> void:

	# Si no se seleccionó una basura,
	# utilizar la más cercana.
	if body == null:
		body = get_entidad_mas_cercana()

	if not is_instance_valid(body):
		return

	if body.is_queued_for_deletion():
		return

	if not cuerpos.has(body):
		return

	if cooldown_activo:
		return

	if jugador.energia_componente.energia <= 0:
		print("No tienes energía")
		return

	if Inventario.peso >= Inventario.peso_maximo:
		print("Inventario lleno")
		return

	revisar_tipo_de_basura(body)

# =========================================
# REVISAR TIPO DE BASURA
# =========================================


func revisar_tipo_de_basura(body:) -> void:

	if not is_instance_valid(body):
		return

	if body.is_queued_for_deletion():
		return

	if cooldown_activo:
		return

	if jugador.energia_componente.energia <= 0:
		return

	print("Analizando: ", body.name)

	if not revisar_tipo_de_requisito(body):
		print("No cumples los requisitos")
		return

	# Basura que necesita golpes.
	if body.data.veces_a_golpear > 0:
		print("Basura pesada")
		body.romper()
		return

	# Basura lista para recolectar.
	recolectar_basura(body)

# =========================================
# REVISAR REQUISITOS
# =========================================


func revisar_tipo_de_requisito(body: Basura) -> bool:

	if not is_instance_valid(body):
		return false

	# Sin requisitos.
	if not body.requisito:
		return true

	match body.tipo_de_requisito:

		body.tipo_de_requisito_Enum.PICO:
			if body.nivel_requisito <= jugador.estadisticas_componente.pico:
				return true

		body.tipo_de_requisito_Enum.HACHA:
			if body.nivel_requisito <= jugador.estadisticas_componente.hacha:
				return true

		body.tipo_de_requisito_Enum.AZADA:
			if body.nivel_requisito <= jugador.estadisticas_componente.azada:
				return true

	print("Necesitas mejorar tus herramientas")
	return false

# =========================================
# RECOLECTAR BASURA
# =========================================


func recolectar_basura(body) -> void:

	if not is_instance_valid(body):
		return

	if body.is_queued_for_deletion():
		return

	if cooldown_activo:
		return

	cooldown_activo = true
	timer.start(cooldown_tiempo)

	print("Recolectando: ", body.name)

	# Retirar el objeto antes de recolectarlo.
	quitar_cuerpo(body)
	if body.has_method("collect"):
		body.collect()

	jugador.energia_componente.agotar(1)

	actualizar_resaltado()

# =========================================
# QUITAR CUERPO DEL RADAR
# =========================================


func quitar_cuerpo(body: Basura) -> void:

	cuerpos.erase(body)

	if not is_instance_valid(body):
		return

	if body.is_queued_for_deletion():
		return

	body.en_area_jugador = false
	body.resaltado_componente.no_resaltado()

	if objeto_resaltado == body:
		objeto_resaltado = null

# =========================================
# INTERACCIÓN POR CLIC
# =========================================


func click_en_basura(objeto: Basura) -> void:

	if not is_instance_valid(objeto):
		return

	if objeto.is_queued_for_deletion():
		return

	if not cuerpos.has(objeto):
		return

	revisar_espacio_inventario(objeto)

# =========================================
# ENTRADA DE CUERPOS
# =========================================


func _on_body_entered(body: Node2D) -> void:

	if not body is Basura:
		return

	if body.is_queued_for_deletion():
		return

	if cuerpos.has(body):
		return

	cuerpos.append(body)

	body.en_area_jugador = true

	actualizar_resaltado()

# =========================================
# SALIDA DE CUERPOS
# =========================================


func _on_body_exited(body: Node2D) -> void:

	if not body is Basura:
		return

	quitar_cuerpo(body)

	actualizar_resaltado()

# =========================================
# COOLDOWN
# =========================================


func _on_timer_timeout() -> void:
	cooldown_activo = false
	print("Cooldown terminado")
