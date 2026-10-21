@icon("res://addons/iconos/estadisticas.svg")
class_name EstadisticasComponente extends Node

var golpe: int = 1
@export var pico: int = 0
@export var hacha: int = 0
@export var azada: int = 0


func _ready() -> void:
	NivelesDeExperiencia.niveles_actualizados.connect(actualizar_herramientas)
	actualizar_herramientas()


func actualizar_herramientas() -> void:
	# La primera herramienta se desbloquea en nivel 3; nivel 5 da herramienta 3.
	pico = maxi(NivelesDeExperiencia.nivel_pico - 1, maxi(0, NivelesDeExperiencia.nivel_resistencia - 2))
	hacha = maxi(NivelesDeExperiencia.nivel_hacha - 1, maxi(0, NivelesDeExperiencia.nivel_cooldown - 2))
	azada = maxi(NivelesDeExperiencia.nivel_azada - 1, maxi(0, NivelesDeExperiencia.nivel_rango - 2))
