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
	input_recoger_obstaculo()


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


func get_entidad_aleatoria() -> Obstaculo:
	if cuerpos.is_empty():
		return null

	var indice = randi() % cuerpos.size() # usa % para conseguir un numero valido 
	return cuerpos[indice]


func input_recoger_obstaculo():
	if Input.is_action_just_pressed("Interaccion"):
		# 1. Obtenemos los datos del ítem "Obstaculo" (puede ser null)
		var recurso_Obstaculo = Inventario.get_item_resource("Obstaculo")
		var cantidad_actual = Inventario.get_count("Obstaculo")

		# CASO 1: NO EXISTE LA Obstaculo EN EL INVENTARIO
		# (Si recurso_Obstaculo es null, significa que ni siquiera hay una ranura para Obstaculo)
		if recurso_Obstaculo == null:
			#print("VACIO - No existe el ítem, recogiendo por primera vez")
			accion_de_recogida()

		# CASO 2: YA EXISTE LA Obstaculo, PERO NO ESTÁ LLENO
		# (Ya sabemos que existe, así que podemos preguntar cuánto tiene sin peligro)
		elif cantidad_actual < recurso_Obstaculo.cantidad_maxima:
			#print("AUN ESPACIO - Recogiendo más Obstaculo")
			accion_de_recogida()

		# CASO 3: YA EXISTE LA Obstaculo Y ESTÁ COMPLETAMENTE LLENO
		else: # Si no se cumplió lo de arriba, significa que cantidad_actual >= cantidad_maxima
			print("ta lleno - No se puede recoger más")


func accion_de_recogida():
	var body = get_entidad_aleatoria()

	if body != null and jugador.energia_componente.energia > 0 and !cooldown_activo:
		if body.requisito:
			match body.tipo_de_requisito:
				body.tipo_de_requisito_Enum.RECOGIDA:
					pass

				body.tipo_de_requisito_Enum.FUERZA:
					if body.nivel_requisito <= jugador.estadisticas_componente.fuerza:
						recolectar_obstaculo()
					elif body.nivel_requisito > jugador.estadisticas_componente.fuerza:
						print("Compra niveles de fuerza")


func recolectar_obstaculo():
	timer.wait_time = cooldown_tiempo
	timer.start()
	cooldown_activo = true
	print("Cooldown activo")
	get_entidad_aleatoria().collect()
	jugador.energia_componente.agotar(1)


func click_en_Obstaculo(objeto):
	if cuerpos.has(objeto) and jugador.energia_componente.energia > 0 and !cooldown_activo:
		timer.wait_time = cooldown_tiempo
		timer.start()
		cooldown_activo = true
		print("Cooldown activo")
		objeto.collect()
		jugador.energia_componente.agotar(1)


func _on_timer_timeout():
	cooldown_activo = false
	print("Cooldown terminado")
