@icon("res://addons/iconos/Auto Ataque.svg")
class_name AutoAtaque extends Node

@export var inventario: HechizoInventario
@export var factory: HechizoFactory
@export var radar_componente: RadarComponente

var timers: Dictionary = {}


func data_hechizo_timer():
	pass

func _ready():
	if not inventario:
		inventario = get_parent().get_node_or_null("HechizoInventario")

	_configurar_timers()

	if not factory:
		factory = get_parent().get_node_or_null("HechizoFactory")

		if not factory:
			factory = get_tree().get_first_node_in_group("HechizoFactory")

	if not factory:
		print("ERROR: No se encontró HechizoFactory")
		return


func _configurar_timers():
	for hechizo in inventario.obtener_todos():
		_crear_timer_para_hechizo(hechizo)


func _crear_timer_para_hechizo(hechizo: HechizoData):
	var timer = Timer.new()
	timer.name = ("Timer " + hechizo.id) #identificador de timer
	timer.wait_time = hechizo.tiempodeataque # 0.5 segundos entre ataques
	timer.one_shot = false
	timer.timeout.connect(_on_autoattack.bind(hechizo))
	add_child(timer)
	timer.start()
	timers[hechizo.id] = timer


func _on_autoattack(hechizo_data: HechizoData): # ← Recibir el hechizo
	if not factory:
		print("ERROR: factory es null")
		return

	# Buscar objetivo
	var objetivo = null

	if radar_componente:
		objetivo = radar_componente.get_entidad_mas_cercana()

	# Crear hechizo con los datos específicos
	factory.crear_hechizo()
