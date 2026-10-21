@icon("res://addons/iconos/Radar.svg")
class_name RadarComponente extends Area2D

# =========================================
# VARIABLES
# =========================================

var cuerpos: Array[Node2D] = []
var objeto_resaltado: Node2D = null

@onready var jugador: Jugador = $".."
@onready var timer: Timer = %Timer
@onready var basura_collider: CollisionShape2D = %basuraCollider
@onready var loot_collector_shape: CollisionShape2D = $"../Loot Collector/CollisionShape2D"

@export var cooldown_tiempo: float = 1.5

var cooldown_activo: bool = false

# =========================================
# INICIALIZACIÓN
# =========================================


func _ready() -> void:
	SignalBus.interaccion.connect(revisar_espacio_inventario)
	timer.wait_time = cooldown_tiempo
	timer.one_shot = true

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
# VALIDAR TIPOS DE OBJETOS
# =========================================


func es_objeto_recolectable(body: Node2D) -> bool:
	return body is Basura or body is BolsaDeBasura


func objeto_disponible(body: Node2D) -> bool:
	if not is_instance_valid(body):
		return false

	if body.is_queued_for_deletion():
		return false

	if not es_objeto_recolectable(body):
		return false
	if body is Basura and body.recogida:
		return false

	# Las bolsas no se pueden recoger durante el vuelo.
	if body is BolsaDeBasura:
		var bolsa: BolsaDeBasura = body

		if not bolsa.puede_recogerse:
			return false

		if bolsa.recogida:
			return false

	return true

# =========================================
# RESALTADO
# =========================================


func obtener_resaltado(body: Node2D) -> ResaltadoComponente:
	if not is_instance_valid(body):
		return null

	if body is Basura:
		var basura: Basura = body
		return basura.resaltado_componente

	if body is BolsaDeBasura:
		var bolsa: BolsaDeBasura = body
		return bolsa.resaltado_componente

	return null


func cambiar_estado_area(body: Node2D, estado: bool) -> void:
	if not is_instance_valid(body):
		return

	if body is Basura:
		var basura: Basura = body
		basura.en_area_jugador = estado

	elif body is BolsaDeBasura:
		var bolsa: BolsaDeBasura = body
		bolsa.en_area_jugador = estado


func quitar_resaltado(body: Node2D) -> void:
	var resaltado := obtener_resaltado(body)

	if resaltado != null:
		resaltado.no_resaltado()

# =========================================
# LIMPIAR CUERPOS
# =========================================


func limpiar_cuerpos() -> void:
	var cuerpos_detectados: Array[Node2D] = []

	for body in get_overlapping_bodies():
		if objeto_disponible(body):
			cuerpos_detectados.append(body)

	for i in range(cuerpos.size() - 1, -1, -1):
		var body: Node2D = cuerpos[i]

		if not is_instance_valid(body):
			cuerpos.remove_at(i)
			continue

		if not cuerpos_detectados.has(body):
			cambiar_estado_area(body, false)
			quitar_resaltado(body)

			if objeto_resaltado == body:
				objeto_resaltado = null

			cuerpos.remove_at(i)

	for body in cuerpos_detectados:
		if not cuerpos.has(body):
			cuerpos.append(body)
			cambiar_estado_area(body, true)

# =========================================
# OBJETO MÁS CERCANO
# =========================================


func get_entidad_mas_cercana() -> Node2D:
	var objeto_cercano: Node2D = null
	var distancia_minima: float = INF

	for obj in cuerpos:
		if not objeto_disponible(obj):
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
	var objeto_cercano: Node2D = get_entidad_mas_cercana()

	if objeto_cercano == objeto_resaltado:
		return

	if is_instance_valid(objeto_resaltado):
		quitar_resaltado(objeto_resaltado)

	objeto_resaltado = objeto_cercano

	if is_instance_valid(objeto_resaltado):
		var resaltado := obtener_resaltado(objeto_resaltado)

		if resaltado != null:
			resaltado.resaltado()

# =========================================
# COMPROBAR INVENTARIO
# =========================================


func revisar_espacio_inventario(body: Node2D = null) -> void:
	if Interfaces.juego_bloqueado():
		return
	limpiar_cuerpos()

	if body == null:
		body = get_entidad_mas_cercana()

	if not objeto_disponible(body):
		return

	if not cuerpos.has(body):
		return

	if cooldown_activo:
		return

	if jugador.energia_componente.energia <= 0:
		print("No tienes energía")
		return

	var peso_objeto: int = 1

	if body is BolsaDeBasura:
		var bolsa: BolsaDeBasura = body
		peso_objeto = bolsa.peso_contenido

	if Inventario.peso + peso_objeto > Inventario.peso_maximo:
		print("No tienes espacio suficiente")
		return

	revisar_tipo_de_basura(body)

# =========================================
# REVISAR TIPO DE BASURA
# =========================================


func revisar_tipo_de_basura(body: Node2D) -> void:
	if not objeto_disponible(body):
		return

	if cooldown_activo:
		return

	if jugador.energia_componente.energia <= 0:
		return

	print("Analizando: ", body.name)

	# CASO 1: Bolsa lanzada.
	if body is BolsaDeBasura:
		recolectar_basura(body)
		return

	# CASO 2: Basura normal.
	if body is Basura:
		var basura: Basura = body

		if not revisar_tipo_de_requisito(basura):
			print("No cumples los requisitos")
			return

		if basura.golpes_restantes > 0:
			print("Basura pesada")
			basura.romper()
			return

		recolectar_basura(basura)

# =========================================
# REVISAR REQUISITOS
# =========================================


func revisar_tipo_de_requisito(body: Basura) -> bool:
	if not is_instance_valid(body):
		return false

	if not body.requisito:
		return true

	match body.tipo_de_requisito:

		body.tipo_de_requisito_Enum.PICO:
			return body.nivel_requisito <= jugador.estadisticas_componente.pico

		body.tipo_de_requisito_Enum.HACHA:
			return body.nivel_requisito <= jugador.estadisticas_componente.hacha

		body.tipo_de_requisito_Enum.AZADA:
			return body.nivel_requisito <= jugador.estadisticas_componente.azada

	print("Necesitas mejorar tus herramientas")
	return false

# =========================================
# RECOLECTAR BASURA
# =========================================


func recolectar_basura(body: Node2D) -> void:
	if not objeto_disponible(body):
		return

	if cooldown_activo:
		return

	if not body.has_method("collect"):
		return

	# Ejecutar la recogida.
	var resultado = body.call("collect")

	# Si collect() devuelve null, no se recogió.
	if resultado == null:
		return

	cooldown_activo = true
	timer.start(cooldown_tiempo)

	print("Recolectando: ", body.name)

	quitar_cuerpo(body)

	jugador.energia_componente.agotar(1)

	actualizar_resaltado()

# =========================================
# QUITAR CUERPO
# =========================================


func quitar_cuerpo(body: Node2D) -> void:
	cuerpos.erase(body)

	if not is_instance_valid(body):
		return

	cambiar_estado_area(body, false)
	quitar_resaltado(body)

	if objeto_resaltado == body:
		objeto_resaltado = null

# =========================================
# INTERACCIÓN POR CLIC
# =========================================


func click_en_basura(objeto: Node2D) -> void:
	if not objeto_disponible(objeto):
		return

	if not cuerpos.has(objeto):
		return

	revisar_espacio_inventario(objeto)

# =========================================
# ENTRADA DE CUERPOS
# =========================================


func _on_body_entered(body: Node2D) -> void:
	if not objeto_disponible(body):
		return

	if cuerpos.has(body):
		return

	cuerpos.append(body)
	cambiar_estado_area(body, true)

	actualizar_resaltado()

# =========================================
# SALIDA DE CUERPOS
# =========================================


func _on_body_exited(body: Node2D) -> void:
	if not es_objeto_recolectable(body):
		return

	quitar_cuerpo(body)
	actualizar_resaltado()

# =========================================
# COOLDOWN
# =========================================


func _on_timer_timeout() -> void:
	cooldown_activo = false
	print("Cooldown terminado")
