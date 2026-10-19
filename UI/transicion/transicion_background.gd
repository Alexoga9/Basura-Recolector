extends Control

@onready var color_rect: ColorRect = %ColorRect

## Estado actual de la transición.
enum Estado {NINGUNO, SALIENDO, ENTRANDO}

var estado: Estado = Estado.NINGUNO

## Velocidad de la transición (unidades de shader por segundo).
@export var velocidad: float = 3.0

## Rango del shader.
const SHADER_MIN := -1.0
const SHADER_MAX := 2.0


func _ready():
	# Al cargar la escena, empezar en "entrando" (desde oscuro a claro)
	estado = Estado.ENTRANDO
	_iniciar_entrada()
	SignalBus.hacer_transicion.connect(_on_hacer_transicion)


func _physics_process(delta: float) -> void:
	if estado == Estado.NINGUNO:
		return

	var valor := _obtener_shader()
	var objetivo: float
	var signo: float

	match estado:
		Estado.SALIENDO:
			objetivo = SHADER_MAX
			signo = 1.0

		Estado.ENTRANDO:
			objetivo = SHADER_MIN
			signo = -1.0

		_:
			return

	valor += signo * velocidad * delta
	valor = clamp(valor, SHADER_MIN, SHADER_MAX)
	_establecer_shader(valor)

	# Comprobar si llegamos al objetivo
	if (signo > 0 and valor >= objetivo) or (signo < 0 and valor <= objetivo):
		_finalizar_transicion()


# ------------------------------------------------------------------
# API
# ------------------------------------------------------------------
func _on_hacer_transicion() -> void:
	# Al pedir transición (cambio de escena), empezar a salir
	if estado == Estado.SALIENDO:
		return # ya está saliendo

	estado = Estado.SALIENDO
	_establecer_shader(SHADER_MIN) # partir desde "limpio" para salir
	show()


func _iniciar_entrada() -> void:
	# Al cargar la escena, empezar desde oscuro y aclarar
	_establecer_shader(SHADER_MAX)
	show()


func _finalizar_transicion() -> void:
	match estado:
		Estado.SALIENDO:
			estado = Estado.NINGUNO
			SignalBus.terminar_transicion.emit()
			# No ocultamos todavía: la escena se cambia y la nueva
			# empezará en ENTRANDO.

		Estado.ENTRANDO:
			estado = Estado.NINGUNO
			hide() # ya no hace falta, la transición terminó


# ------------------------------------------------------------------
# Helpers del shader
# ------------------------------------------------------------------
func _obtener_shader() -> float:
	return color_rect.material.get_shader_parameter("progress")


func _establecer_shader(valor: float) -> void:
	color_rect.material.set_shader_parameter("progress", valor)
