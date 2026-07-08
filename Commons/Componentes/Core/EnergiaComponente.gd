@tool
@icon("res://addons/iconos/estamina.svg")
class_name EnergiaComponente extends Node

signal cansado
signal valor_energia_cambiado(nuevo_valor: float)
signal valor_maximo_energia_cambiado(nuevo_max: float)
@onready var recarga_lenta: Timer = %"Recarga lenta"

@export var es_jugador: bool = false

@export var energia: float = 10.0:
	set(valor):
		energia = clamp(valor, 0, energia_maxima)
		valor_energia_cambiado.emit(energia)

		if es_jugador and not Engine.is_editor_hint():
			SignalBus.energia_jugador_cambiada.emit(energia)

		if energia <= 0:
			cansado.emit()
			if es_jugador and not Engine.is_editor_hint():
				SignalBus.murio_jugador.emit()

@export var energia_maxima: float = 10.0:
	set(val):
		energia_maxima = max(val, 1)
		valor_maximo_energia_cambiado.emit(energia_maxima)

		if es_jugador and not Engine.is_editor_hint():
			SignalBus.energia_maxima_jugador_cambiada.emit(energia_maxima)

		if energia > energia_maxima:
			energia = energia_maxima

var energia_inagotable: bool = false
var _inicializado: bool = false


func _ready():
	_inicializado = true
	# NO emitir señales aquí, usar call_deferred para dar tiempo a que todo se conecte
	call_deferred("_emitir_valores_iniciales")
	cansado.connect(activar_timer)

	energia = energia_maxima


func _emitir_valores_iniciales():
	if not _inicializado:
		return

	# Emitir valores iniciales SOLO una vez
	valor_energia_cambiado.emit(energia)
	valor_maximo_energia_cambiado.emit(energia_maxima)

	if es_jugador and not Engine.is_editor_hint():
		SignalBus.energia_jugador_cambiada.emit(energia)
		SignalBus.energia_maxima_jugador_cambiada.emit(energia_maxima)


func recuperar(recuperacion: float):
	if recuperacion > 0 and energia < energia_maxima:
		energia += recuperacion


func agotar(agotamiento: float):
	if agotamiento > 0 and not energia_inagotable:
		energia -= agotamiento


func recuperar_por_segundo(recuperacion_por_segundo: float):
	if recuperacion_por_segundo > 0:
		recuperar(recuperacion_por_segundo)


func agotar_por_segundo(agotamiento_por_segundo: float):
	if agotamiento_por_segundo > 0:
		agotar(agotamiento_por_segundo)


func aumentar_energia_maxima(aumento: float):
	if aumento > 0:
		energia_maxima += aumento


func reducir_energia_maxima(reduccion: float):
	if reduccion > 0:
		energia_maxima = max(energia_maxima - reduccion, 1)


func frames_de_energia_inagotable():
	if energia_inagotable:
		# Aquí iría la lógica de invencibilidad con timer
		pass


func _on_hurtbox_agotamiento_recibido(agotamiento: float):
	agotar(agotamiento)


func activar_timer():
	recarga_lenta.start()


func _on_recarga_lenta_timeout():
	if energia < 2:
		recuperar_por_segundo(1)
	elif energia == 2:
		recarga_lenta.stop()
