@tool
@icon("res://addons/iconos/estamina.svg")
class_name EnergiaComponente extends Node

signal murio
signal valor_vida_cambiado(nuevo_valor: float)
signal valor_maximo_vida_cambiado(nuevo_max: float)

@export var es_jugador: bool = false

@export var vida: float = 10.0:
	set(valor):
		vida = clamp(valor, 0, vida_maxima)
		valor_vida_cambiado.emit(vida)

		if es_jugador and not Engine.is_editor_hint():
			SignalBus.vida_jugador_cambiada.emit(vida)

		if vida <= 0:
			murio.emit()
			if es_jugador and not Engine.is_editor_hint():
				SignalBus.murio_jugador.emit()

@export var vida_maxima: float = 10.0:
	set(val):
		vida_maxima = max(val, 1)
		valor_maximo_vida_cambiado.emit(vida_maxima)

		if es_jugador and not Engine.is_editor_hint():
			SignalBus.vida_maxima_jugador_cambiada.emit(vida_maxima)

		if vida > vida_maxima:
			vida = vida_maxima

var invicibilidad: bool = false
var _inicializado: bool = false


func _ready():
	_inicializado = true
	# NO emitir señales aquí, usar call_deferred para dar tiempo a que todo se conecte
	call_deferred("_emitir_valores_iniciales")

	vida = vida_maxima


func _emitir_valores_iniciales():
	if not _inicializado:
		return

	# Emitir valores iniciales SOLO una vez
	valor_vida_cambiado.emit(vida)
	valor_maximo_vida_cambiado.emit(vida_maxima)

	if es_jugador and not Engine.is_editor_hint():
		SignalBus.vida_jugador_cambiada.emit(vida)
		SignalBus.vida_maxima_jugador_cambiada.emit(vida_maxima)


func curar(curacion: float):
	if curacion > 0 and vida < vida_maxima:
		vida += curacion


func dañar(daño: float):
	if daño > 0 and not invicibilidad:
		vida -= daño


func curar_por_segundo(curacion_por_segundo: float):
	if curacion_por_segundo > 0:
		curar(curacion_por_segundo)


func dañar_por_segundo(daño_por_segundo: float):
	if daño_por_segundo > 0:
		dañar(daño_por_segundo)


func aumentar_vida_maxima(aumento: float):
	if aumento > 0:
		vida_maxima += aumento


func reducir_vida_maxima(reduccion: float):
	if reduccion > 0:
		vida_maxima = max(vida_maxima - reduccion, 1)


func frames_de_invencibilidad():
	if invicibilidad:
		# Aquí iría la lógica de invencibilidad con timer
		pass


func _on_hurtbox_daño_recibido(daño: float):
	dañar(daño)
