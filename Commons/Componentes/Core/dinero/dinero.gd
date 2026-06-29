#@tool
#@icon("res://addons/iconos/dinero.svg")
#class_name Dinero 
extends Node

signal valor_dinero_cambiado(nuevo_valor: float)

@export var dinero: float = 10.0:
	set(valor):
		valor_dinero_cambiado.emit(dinero)

		if not Engine.is_editor_hint():
			valor_dinero_cambiado.emit(dinero)

		valor_dinero_cambiado.emit(dinero)

var _inicializado: bool = false


func _ready():
	_inicializado = true
	# NO emitir señales aquí, usar call_deferred para dar tiempo a que todo se conecte
	call_deferred("_emitir_valores_iniciales")


func _emitir_valores_iniciales():
	if not _inicializado:
		return

	# Emitir valores iniciales SOLO una vez
	valor_dinero_cambiado.emit(dinero)

	#if not Engine.is_editor_hint():
		#SignalBus.dinero_jugador_cambiada.emit(dinero)

	valor_dinero_cambiado.emit(dinero)


func ganar(ganancia: float):
	if ganancia > 0:
		dinero += ganancia


func gastar(gastado: float):
	if gastado > 0:
		dinero -= gastado


func ganar_por_segundo(ganancia_por_segundo: float):
	if ganancia_por_segundo > 0:
		ganar(ganancia_por_segundo)


func gastar_por_segundo(gastado_por_segundo: float):
	if gastado_por_segundo > 0:
		gastar(gastado_por_segundo)
