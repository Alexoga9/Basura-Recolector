extends Node

signal niveles_actualizados

var nivel_resistencia: int = 1
var nivel_cooldown: int = 1
var nivel_rango: int = 1
var nivel_peso: int = 1
var nivel_lanzamiento: int = 1
var nivel_refrescos: int = 1
var nivel_golpe: int = 1
var nivel_pico: int = 1
var nivel_hacha: int = 1
var nivel_azada: int = 1


## Devuelve un diccionario con todos los niveles.
func serializar() -> Dictionary:
	return {
		"nivel_resistencia": nivel_resistencia,
		"nivel_cooldown": nivel_cooldown,
		"nivel_rango": nivel_rango,
		"nivel_peso": nivel_peso,
		"nivel_lanzamiento": nivel_lanzamiento,
		"nivel_refrescos": nivel_refrescos,
		"nivel_golpe": nivel_golpe,
		"nivel_pico": nivel_pico,
		"nivel_hacha": nivel_hacha,
		"nivel_azada": nivel_azada,
	}


## Aplica un diccionario de niveles. Los campos que falten no se tocan.
func deserializar(datos: Dictionary) -> void:
	for clave in datos:
		if clave in self:
			set(clave, datos[clave])
	niveles_actualizados.emit()


## Resetea todos los niveles a 1.
func reset() -> void:
	nivel_resistencia = 1
	nivel_cooldown = 1
	nivel_rango = 1
	nivel_peso = 1
	nivel_lanzamiento = 1
	nivel_refrescos = 1
	nivel_golpe = 1
	nivel_pico = 1
	nivel_hacha = 1
	nivel_azada = 1
	niveles_actualizados.emit()
