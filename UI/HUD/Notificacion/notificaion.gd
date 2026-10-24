class_name Notificacion extends Control

enum Estado {OCULTA, ENTRANDO, VISIBLE, SALIENDO}

## Posición X (global) donde la notificación queda visible.
@export var x_reposo: float = 0.0
@export var duracion_entrada: float = 0.35
@export var duracion_salida: float = 0.3
## true: sale por el lado derecho (como antes). false: vuelve por donde entró.
@export var salir_por_la_derecha: bool = true
## Espacio extra fuera de pantalla para que no se vea ningún borde.
@export var margen: float = 16.0

@onready var label: Label = %Label
@onready var timer: Timer = %Timer

var _estado: Estado = Estado.OCULTA
var _tween: Tween


func _ready() -> void:
	timer.one_shot = true
	SignalBus.notificacion.connect(mostrar)

	# Empieza escondida fuera de pantalla, sin animación inicial
	_colocar_oculta()


# ------------------------------------------------------------------
# API
# ------------------------------------------------------------------
func recibir_texto(texto: String) -> void:
	label.text = texto


func mostrar(texto: String) -> void:
	# El texto se actualiza SIEMPRE al instante, sin esperar a ninguna animación
	recibir_texto(texto)

	match _estado:
		Estado.VISIBLE:
			# Ya está en pantalla: solo reiniciamos el tiempo visible
			timer.start()

		Estado.ENTRANDO:
			# Ya viene entrando con el texto nuevo: nada más que hacer
			pass

		Estado.OCULTA, Estado.SALIENDO:
			# Si estaba saliendo, vuelve desde donde esté (sin saltos)
			timer.stop()
			_animar_entrada()


# ------------------------------------------------------------------
# Animaciones
# ------------------------------------------------------------------
func _animar_entrada() -> void:
	_matar_tween()
	_estado = Estado.ENTRANDO
	show()

	# Duración proporcional a lo que falta recorrer (transición continua)
	var x_inicio := _x_oculta_izquierda()
	var recorrido_total := maxf(x_reposo - x_inicio, 1.0)
	var restante := absf(x_reposo - global_position.x)
	var duracion := duracion_entrada * clampf(restante / recorrido_total, 0.2, 1.0)

	_tween = create_tween()
	_tween.tween_property(self, "global_position:x", x_reposo, duracion) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) # arranca rápido, frena suave al llegar

	_tween.tween_callback(_on_entrada_terminada)


func _animar_salida() -> void:
	_matar_tween()
	_estado = Estado.SALIENDO

	var destino := _x_oculta_derecha() if salir_por_la_derecha else _x_oculta_izquierda()

	_tween = create_tween()
	_tween.tween_property(self, "global_position:x", destino, duracion_salida) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) # arranca suave, acelera al salir

	_tween.tween_callback(_on_salida_terminada)


func _on_entrada_terminada() -> void:
	_estado = Estado.VISIBLE
	timer.start() # el tiempo visible se cuenta desde que llegó


func _on_salida_terminada() -> void:
	_colocar_oculta()


func _on_timer_timeout() -> void:
	if _estado == Estado.VISIBLE:
		_animar_salida()


# ------------------------------------------------------------------
# Utilidades
# ------------------------------------------------------------------
func _colocar_oculta() -> void:
	_matar_tween()
	_estado = Estado.OCULTA
	global_position.x = _x_oculta_izquierda()
	hide()


func _matar_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()


# Se calculan al momento, así funcionan si cambia el tamaño de la ventana
func _x_oculta_izquierda() -> float:
	return -(size.x * scale.x) - margen


func _x_oculta_derecha() -> float:
	return get_viewport_rect().size.x + margen
