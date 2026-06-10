@icon("res://addons/iconos/Perseguir.svg")
class_name PerseguirComponente extends Node

enum Objetivo {QUIETO, JUGADOR, PERSONALIZABLE, LINEA_RECTA, SIN_OBJETIVO}
@export var modo: Objetivo = Objetivo.QUIETO

@onready var jugador = Global.jugador
@export var body: Node2D # el que persigue
@export var objetivo_personalizado: Node2D = null # el perseguido

# Variables para línea recta
var direccion_linea_recta: Vector2 = Vector2.RIGHT
var ultima_direccion_input: Vector2 = Vector2.RIGHT

# Variables para línea recta
var direccion_inicial_bloqueada: Vector2 = Vector2.ZERO
var direccion_bloqueada: bool = false
@onready var marker: Marker2D = Global.jugador.marker_2d


func _ready():
	# Guardar dirección inicial basada en la rotación del body
	if body:
		direccion_inicial_bloqueada = body.transform.x

	SignalBus.input_movimiento.connect(mover_linea_recta)


func modo_de_persecucion(objetivo_personalizado: Node2D = null, delta: float = 0.0) -> Vector2:

	match modo:
		Objetivo.QUIETO:
			return Vector2.ZERO

		Objetivo.JUGADOR:
			return perseguir_jugador()

		Objetivo.PERSONALIZABLE:
			return perseguir_objetivo(objetivo_personalizado)

		Objetivo.LINEA_RECTA:
			return mover_linea_recta(objetivo_personalizado)

		Objetivo.SIN_OBJETIVO:
			return mover_sin_objetivo()

	# Este return es por si acaso (aunque nunca debería llegar aquí)
	return Vector2.RIGHT


func perseguir_jugador() -> Vector2:
	if jugador:
		return body.global_position.direction_to(jugador.global_position)

	return Vector2.ZERO


func perseguir_objetivo(objetivo_obj: Node2D) -> Vector2:
	if direccion_bloqueada and objetivo_obj == null:
		return direccion_inicial_bloqueada

	if objetivo_obj and is_instance_valid(objetivo_obj):
		direccion_inicial_bloqueada = body.global_position.direction_to(objetivo_obj.global_position)
		return direccion_inicial_bloqueada

	return Vector2.ZERO


func mover_linea_recta(objetivo_inicial: Node2D = null) -> Vector2:
	# Si ya tenemos la dirección bloqueada, solo retornarla
	if direccion_bloqueada:
		return direccion_inicial_bloqueada

	# Primera vez: calcular dirección basada en el objetivo (si existe)
	if objetivo_inicial and is_instance_valid(objetivo_inicial):
		direccion_inicial_bloqueada = body.global_position.direction_to(objetivo_inicial.global_position)
		direccion_bloqueada = true
		return direccion_inicial_bloqueada

	# Si no hay objetivo, usar dirección por defecto
	if direccion_inicial_bloqueada == Vector2.ZERO: # aqui sustituir con marker
		direccion_inicial_bloqueada = mover_sin_objetivo()
		direccion_bloqueada = true

	return direccion_inicial_bloqueada


func mover_sin_objetivo() -> Vector2:
	if direccion_bloqueada:
		return direccion_inicial_bloqueada

	if marker and is_instance_valid(marker):
		direccion_inicial_bloqueada = marker.transform.x
		direccion_bloqueada = true
		return direccion_inicial_bloqueada

	# Fallback: moverse hacia la derecha
	return Vector2.RIGHT


#func _actualizar_direccion_por_input(valor):
	## Obtener input del jugador desde su componente
	#
#
	#if valor != Vector2.ZERO:
		#direccion_linea_recta = valor
		#return direccion_linea_recta
#
	#return Vector2.ZERO
#
	## Fallback: mantener dirección actual


func set_direccion_linea_recta(nueva_direccion: Vector2):
	direccion_linea_recta = nueva_direccion.normalized()
	ultima_direccion_input = direccion_linea_recta


# NUEVO: Reiniciar el bloqueo (útil para reutilizar el componente)
func resetear_direccion_bloqueada():
	direccion_bloqueada = false
	direccion_inicial_bloqueada = Vector2.ZERO


func reset_direccion():
	direccion_linea_recta = ultima_direccion_input


func movimiento_raro_con_jugador():
	# esta vaina mueve a los hechizos instanciados segun el 
	# input del jugador del wasd
	direccion_linea_recta = Global.jugador.input_componente.input_movimiento()
	return direccion_linea_recta
