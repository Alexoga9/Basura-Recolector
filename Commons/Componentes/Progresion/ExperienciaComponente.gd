@tool
@icon("res://addons/iconos/LevelUp.svg")
class_name ExperienciaComponente extends Node

signal subir_de_nivel
signal valor_xp_cambiado(nuevo_valor: float)
signal valor_maximo_xp_cambiado(nuevo_max: float)

# experiencia
@export var xp_actual: float = 0.0:
	set(valor):
		xp_actual = clamp(valor, 0, xp_max)
		valor_xp_cambiado.emit(xp_actual)
		SignalBus.valor_xp_cambiado.emit(xp_actual)

@export var xp_max: float = 10.0:
	set(valor):
		xp_max = max(valor, 1)
		valor_maximo_xp_cambiado.emit(xp_max)
		SignalBus.valor_xp_maximo_cambiado.emit(xp_max)

#var experiencia: int = 0
var nivel: int = 1
var experiencia_recogida: float = 0.0

var _inicializado: bool = false


func _ready():
	# Inicializar valores
	xp_max = calcular_xp_max()
	xp_actual = 0.0
	valor_xp_cambiado.emit(xp_actual)
	valor_maximo_xp_cambiado.emit(xp_max)
	call_deferred("_emitir_valores_iniciales")


func _emitir_valores_iniciales():
	if not _inicializado:
		return

	# Emitir valores iniciales SOLO una vez
	valor_xp_cambiado.emit(xp_actual)
	valor_maximo_xp_cambiado.emit(xp_max)

	if not Engine.is_editor_hint():
		SignalBus.valor_xp_cambiado.emit(xp_actual)
		SignalBus.valor_xp_maximo_cambiado.emit(xp_max)


func sumar_xp(xp):
	experiencia_recogida += xp


func restar_xp(xp):
	experiencia_recogida -= xp - xp_actual


func calcular_xp(xp):
	sumar_xp(xp)

	if xp_actual + experiencia_recogida <= xp_max:
		xp_actual += experiencia_recogida # aqui sumaremos experiencia
		experiencia_recogida = 0

	else: # aqui subimos de nivel
		level_up()

	print("ahora tengo de XP " + str(xp_actual))


func calcular_xp_max():

	xp_max = nivel * 10

	#if nivel < 20:
		#xp_max = nivel * 5

	#elif nivel > 40:
		#xp_max + 95 *(nivel - 19) * 8

	#else:
		#xp_max = 255 + (nivel - 390) * 12
#
	return xp_max


func level_up():
	nivel += 1
	restar_xp(xp_max)
	xp_actual = experiencia_recogida
	calcular_xp_max()
	print("Subi de nivel, ahora necesito " + str(xp_max) + " y soy nivel " + str(nivel))
	subir_de_nivel.emit()
	SignalBus.subir_de_nivel.emit(nivel)
