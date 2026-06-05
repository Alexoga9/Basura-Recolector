@icon("res://addons/iconos/Hechizo Componente.svg")
class_name HechizoComponente extends Node

#@export var data: HechizoData
@export var hechizo_inventario: HechizoInventario

var data: HechizoData

var municion: int
var tiempo_entre_ataques: float


func _ready():
	data = hechizo_inventario.get_primer_hechizo()
	referencia_hechizo()


func referencia_hechizo():
	data = hechizo_inventario.get_primer_hechizo()


# Usar la referencia del jugador para que la use hechizo factory
func usar(pos, dir):
	pass


func puede_usar() -> bool:
	pass
	return true


func actualizar_cooldown(delta):
	pass


func _on_proyectil_destruido():
	pass


func set_spawneo():
	match data.tipo_de_spawneo:
		data.Spawneabilidad.UNICO:
			#print("uno solo")
			return

		data.Spawneabilidad.FIJO:
			#print("una cantidad x")
			return

		data.Spawneabilidad.MULTIPLE:
			#print("siempre estara instanciando")
			return

	print_rich("[color=orange][shake]" + name + "[/shake][/color]" + " no spawnea :v ")


func dar_datos_a_hechizo_entidad(hechizo):
	#hechizo.municion = data.municion
	#hechizo.tiempodeataque = data.tiempodeataque
	hechizo.velocidad = data.velocidad
	hechizo.rotacion = data.rotacion
	hechizo.tamaño = data.tamaño
	hechizo.precision = data.precision
	hechizo.daño_primario = data.daño_primario
	#hechizo.daño_secundario = data.daño_secundario
	#hechizo.comportamiento = data.comportamiento
