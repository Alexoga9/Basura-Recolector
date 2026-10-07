@icon("res://addons/iconos/Radar.svg")
class_name RadarComponente extends Area2D

var cuerpos: Array[Basura] = []

@onready var jugador: Jugador = $".."
@onready var timer: Timer = %Timer
@onready var basura_collider:CollisionShape2D = %basuraCollider

@export var cooldown_tiempo: float = 3
var cooldown_activo: bool = false


func _ready():
	SignalBus.interaccion.connect(revisar_espacio_inventario)
	timer.wait_time = cooldown_tiempo


func revisar_espacio_inventario():
	var body = get_entidad_mas_cercana()

	# CASO 1: Hay espacio en el inventario
	if Inventario.peso_maximo > Inventario.peso:
		print("Revisando basura")
		revisar_tipo_de_basura(body)

	# CASO 2: Inventario lleno
	else:
		print("ta lleno - No se puede recoger más")


func revisar_tipo_de_basura(body: Basura):
	if body == null:
		return

	if jugador.energia_componente.energia <= 0:
		return

	if cooldown_activo:
		return

	print("analizando")

# 🔑 AHORA SÍ: chequear requisito y salir si falla
	if not revisar_tipo_de_requisito(body):
		return

	if body.data.veces_a_golpear > 0:
		print("Basura pesada")
		body.romper()
		return

	recolectar_basura(body)


## Devuelve true si se cumplen los requisitos (o no hay requisitos), false si no.
func revisar_tipo_de_requisito(body: Basura) -> bool:
	print("revisando requisito")

	if body == null:
		return false

	# Sin requisito → pasa
	if not body.requisito:
		return true

	match body.tipo_de_requisito:
		body.tipo_de_requisito_Enum.PICO:
			if body.nivel_requisito <= jugador.estadisticas_componente.pico:
				return true

		body.tipo_de_requisito_Enum.HACHA:
			if body.nivel_requisito <= jugador.estadisticas_componente.hacha:
				return true

		body.tipo_de_requisito_Enum.AZADA:
			if body.nivel_requisito <= jugador.estadisticas_componente.azada:
				return true

			print("Compra niveles de fuerza")
			return false

	# Si llega aquí, tipo de requisito desconocido
	return false


func recolectar_basura(basura: Basura):
	timer.wait_time = cooldown_tiempo
	timer.start()
	cooldown_activo = true
	print("Cooldown activo")
	basura.collect()
	jugador.energia_componente.agotar(1)


func click_en_basura(objeto): # cambiarde forma que use revisar_tipo_de_basura()
	if cuerpos.has(objeto) and jugador.energia_componente.energia > 0 and !cooldown_activo:
		revisar_espacio_inventario()


## Devuelve la última entidad que entró al radar (LIFO).
func get_entidad_mas_cercana() -> Basura:
	if cuerpos.is_empty():
		return null

	return cuerpos.pick_random()


func _on_body_entered(body: Basura):
	body.en_area_jugador = true
	body.resaltado_componente.resaltado()
	cuerpos.append(body)


func _on_body_exited(body: Basura):
	body.en_area_jugador = false
	body.resaltado_componente.no_resaltado()
	cuerpos.erase(body)


func _on_timer_timeout():
	cooldown_activo = false
	print("Cooldown terminado")
