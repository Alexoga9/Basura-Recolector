class_name RadarComponenteObstaculos extends Area2D

var cuerpos: Array[Obstaculo]
@onready var jugador: Jugador = $".."
@onready var timer: Timer = %Timer
@onready var Obstaculo_collider:CollisionShape2D = %ObstaculoCollider

@export var cooldown_tiempo: float = 3
var cooldown_activo: bool = false


func _ready():
	timer.wait_time = cooldown_tiempo


func _process(delta):
	revisar_espacio_inventario()


func get_entidad_aleatoria() -> Obstaculo:
	if cuerpos.is_empty():
		return null

	var indice = randi() % cuerpos.size() # usa % para conseguir un numero valido 
	return cuerpos[indice]


func revisar_espacio_inventario():
	if Input.is_action_just_pressed("Interaccion"):
		# 1. Obtenemos los datos del ítem "Obstaculo" (puede ser null)
		var recurso_Obstaculo = Inventario.get_item_resource("Obstaculo")
		var cantidad_actual = Inventario.get_count("Obstaculo")

		# CASO 1: NO EXISTE Obstaculo EN EL INVENTARIO
		if recurso_Obstaculo == null:
			revisar_tipo_de_requisito()

		# CASO 2: YA EXISTE Obstaculo, PERO NO ESTÁ LLENO
		elif cantidad_actual < recurso_Obstaculo.cantidad_maxima:
			revisar_tipo_de_requisito()

		# CASO 3: YA EXISTE LA Obstaculo Y ESTÁ COMPLETAMENTE LLENO
		else:
			print("ta lleno - No se puede recoger más")


func revisar_tipo_de_requisito():
	var body = get_entidad_aleatoria()

	if body != null and jugador.energia_componente.energia > 0 and !cooldown_activo:
		if body.requisito:
			match body.tipo_de_requisito:
				body.tipo_de_requisito_Enum.RECOGIDA:
					pass

				body.tipo_de_requisito_Enum.FUERZA:
					if body.nivel_requisito <= jugador.estadisticas_componente.fuerza:
						recolectar_obstaculo(get_entidad_aleatoria())
					elif body.nivel_requisito > jugador.estadisticas_componente.fuerza:
						print("Compra niveles de fuerza")


func recolectar_obstaculo(obstaculo: Obstaculo):
	timer.wait_time = cooldown_tiempo
	timer.start()
	cooldown_activo = true
	print("Cooldown activo")
	obstaculo.collect()
	jugador.energia_componente.agotar(1)


func click_en_Obstaculo(objeto: Obstaculo):
	if cuerpos.has(objeto) and jugador.energia_componente.energia > 0 and !cooldown_activo:
		recolectar_obstaculo(objeto)


func _on_body_entered(body: Obstaculo):
	print("Obstaculo aqui")
	if body.is_in_group("Obstaculo"):
		body.en_area_jugador = true
		body.resaltado_componente.resaltado()
		cuerpos.append(body)
		#print(cuerpos)


func _on_body_exited(body: Obstaculo):
	if body.is_in_group("Obstaculo"):
		body.en_area_jugador = false
		body.resaltado_componente.no_resaltado()
		cuerpos.erase(body)
		#print(cuerpos)


func _on_timer_timeout():
	cooldown_activo = false
	print("Cooldown terminado")
