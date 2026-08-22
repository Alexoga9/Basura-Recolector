extends StaticBody2D

@onready var mensaje = %msj
@onready var area_deteccion = %Area2D

@export var porcentaje_requerido: int = 80

var jugador_cerca: bool = false
var porcentaje_actual: int = 0
var timer_mensaje: Timer


func _ready() -> void:
	mensaje.visible = false

	# Configuramos los sensores de cercanía
	area_deteccion.body_entered.connect(_al_acercarse)
	area_deteccion.body_exited.connect(_al_alejarse)

	# Escuchamos el progreso y el botón de interacción
	SignalBus.zona_limpida.connect(_actualizar_progreso)
	SignalBus.interaccion.connect(_al_interactuar)

	# Creamos un Timer invisible para controlar cuánto dura el mensaje en pantalla
	timer_mensaje = Timer.new()
	timer_mensaje.one_shot = true # Solo se ejecuta una vez
	timer_mensaje.wait_time = 2.5 # El mensaje durará 2.5 segundos
	add_child(timer_mensaje)
	timer_mensaje.timeout.connect(_ocultar_mensaje)


# --- DETECCIÓN DEL JUGADOR ---
func _al_acercarse(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_cerca = true


func _al_alejarse(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_cerca = false
		_ocultar_mensaje() # Si se va, ocultamos el mensaje de inmediato


# --- ACTUALIZACIÓN DE DATOS ---
func _actualizar_progreso(nuevo_porcentaje: int) -> void:
	# Guardamos el porcentaje que nos manda la barra de progreso
	porcentaje_actual = nuevo_porcentaje


# --- INTERACCIÓN (Cuando el jugador presiona 'E') ---
func _al_interactuar() -> void:
	# Si no está cerca de esta valla, no hacemos nada
	if not jugador_cerca:
		return

	# Verificamos si tiene lo necesario
	if porcentaje_actual >= porcentaje_requerido:
		abrir_paso()
	else:
		mostrar_mensaje_bloqueo()


# --- MANEJO DEL MENSAJE ---
func mostrar_mensaje_bloqueo() -> void:
	mensaje.text = "¡Necesitas " + str(porcentaje_requerido) + "% limpio! \n(Llevas " + str(porcentaje_actual) + "%)"
	mensaje.visible = true
	# Reiniciamos el temporizador para que empiece a contar los 2.5 segundos
	timer_mensaje.start()


func _ocultar_mensaje() -> void:
	mensaje.visible = false


# --- DESBLOQUEO ---
func abrir_paso() -> void:
	SignalBus.zona_limpida.disconnect(_actualizar_progreso)
	SignalBus.interaccion.disconnect(_al_interactuar)
	queue_free()
