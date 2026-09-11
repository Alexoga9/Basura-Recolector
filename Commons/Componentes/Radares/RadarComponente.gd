@icon("res://addons/iconos/Radar.svg")
class_name RadarComponente extends Area2D

var cuerpos: Array[Node2D]

@onready var jugador: Jugador = $".."
@onready var timer: Timer = %Timer

@export var cooldown_tiempo: float = 3
var cooldown_activo: bool = false


func _ready():
	SignalBus.interaccion.connect(revisar_espacio_inventario)
	timer.wait_time = cooldown_tiempo


func revisar_espacio_inventario():

	# 1. Obtenemos los datos del ítem "Basura" (puede ser null)
	var recurso_basura = Inventario.get_item_resource("Basura")
	var recurso_Obstaculo = Inventario.get_item_resource("Obstaculo")
	var cantidad_actual = Inventario.get_count("Basura")

	# CASO 1: NO EXISTE LA BASURA EN EL INVENTARIO
	if recurso_basura == null or recurso_Obstaculo == null:
		revisar_tipo_de_basura()

	# CASO 2: YA EXISTE LA BASURA, PERO NO ESTÁ LLENO
	elif cantidad_actual < recurso_basura.cantidad_maxima:
		revisar_tipo_de_basura()

	# CASO 3: YA EXISTE LA BASURA Y ESTÁ COMPLETAMENTE LLENO
	else:
		print("ta lleno - No se puede recoger más")


func revisar_tipo_de_basura():
	var body = get_entidad_mas_cercana()
	
	if body == Basur

	if body != null and jugador.energia_componente.energia > 0 and !cooldown_activo:
		if body.data.veces_a_golpear > 0:
			print("Basura pesada")
			body.romper()

		elif body.data.veces_a_golpear == 0:
			recolectar_basura(body)


func revisar_tipo_de_requisito():
	var body = get_entidad_mas_cercana()

	if body != null and jugador.energia_componente.energia > 0 and !cooldown_activo:
		if body.requisito:
			match body.tipo_de_requisito:
				body.tipo_de_requisito_Enum.RECOGIDA:
					pass

				body.tipo_de_requisito_Enum.FUERZA:
					if body.nivel_requisito <= jugador.estadisticas_componente.fuerza:
						recolectar_basura(get_entidad_mas_cercana())
					elif body.nivel_requisito > jugador.estadisticas_componente.fuerza:
						print("Compra niveles de fuerza")


func recolectar_basura(basura: Node2D):
	timer.wait_time = cooldown_tiempo
	timer.start()
	cooldown_activo = true
	print("Cooldown activo")
	basura.collect()
	jugador.energia_componente.agotar(1)


func click_en_basura(objeto):
	if cuerpos.has(objeto) and jugador.energia_componente.energia > 0 and !cooldown_activo:
		recolectar_basura(objeto)


## Devuelve la última entidad que entró al radar (LIFO).
func get_entidad_mas_cercana():
	if cuerpos.is_empty():
		return null

	return cuerpos.back()


func _on_body_entered(body: Basura):
	#print("Basura aqui")
	if body.is_in_group("Basura"):
		body.en_area_jugador = true
		body.resaltado_componente.resaltado()
		cuerpos.append(body)


func _on_body_exited(body: Basura):
	if body.is_in_group("Basura"):
		body.en_area_jugador = false
		body.resaltado_componente.no_resaltado()
		cuerpos.erase(body)


func _on_timer_timeout():
	cooldown_activo = false
	print("Cooldown terminado")
