class_name RadarComponenteBasura extends Area2D

var cuerpos: Array[Basura]
@onready var jugador: Jugador = $".."
@onready var timer: Timer = %Timer
@onready var basura_collider:CollisionShape2D = %BasuraCollider

@export var cooldown_tiempo: float = 3
var cooldown_activo: bool = false


func _ready():
	timer.wait_time = cooldown_tiempo


func _process(delta):
	recoger_basura()


func _on_body_entered(body):
	print("Basura aqui")
	if body.is_in_group("Basura"):
		cuerpos.append(body)
		print(cuerpos)


func _on_body_exited(body):
	if body.is_in_group("Basura"):
		cuerpos.erase(body)
		print(cuerpos)


func get_entidad_aleatoria() -> Basura:
	if cuerpos.is_empty():
		return null

	var indice = randi() % cuerpos.size() # usa % para conseguir un numero valido 
	return cuerpos[indice]


func recoger_basura():
	#if Input.is_action_just_pressed("Interaccion"):
		#if Inventario.get_count("Basura") == 0:
			#accion_de_recogida()
			#print(str(Inventario.get_item_resource("Basura").cantidad_maxima))
#
		#if Inventario.get_count("Basura") <= Inventario.get_item_resource("Basura").cantidad_maxima:
			#accion_de_recogida()
			#print("AUN ESPACIO")
#
		#elif Inventario.get_count("Basura") == Inventario.get_item_resource("Basura").cantidad_maxima:
			#print("ta lleno")

	#if Input.is_action_just_pressed("Interaccion"):
		#if Inventario.get_count("Basura") == null:
			#print("VACIO")
			#accion_de_recogida()
#
		#if Inventario.get_item_resource("Basura") != null:
			#if Inventario.get_count("Basura") !=null and Inventario.get_count("Basura") == Inventario.get_item_resource("Basura").cantidad_maxima:
				#print("ta lleno")
#
		#else:
			#accion_de_recogida()
			#print("AUN ESPACIO")

	if Input.is_action_just_pressed("Interaccion"):
		# 1. Obtenemos los datos del ítem "Basura" (puede ser null)
		var recurso_basura = Inventario.get_item_resource("Basura")
		var cantidad_actual = Inventario.get_count("Basura")

		# CASO 1: NO EXISTE LA BASURA EN EL INVENTARIO
		# (Si recurso_basura es null, significa que ni siquiera hay una ranura para basura)
		if recurso_basura == null:
			print("VACIO - No existe el ítem, recogiendo por primera vez")
			accion_de_recogida()

		# CASO 2: YA EXISTE LA BASURA, PERO NO ESTÁ LLENO
		# (Ya sabemos que existe, así que podemos preguntar cuánto tiene sin peligro)
		elif cantidad_actual < recurso_basura.cantidad_maxima:
			print("AUN ESPACIO - Recogiendo más basura")
			accion_de_recogida()

		# CASO 3: YA EXISTE LA BASURA Y ESTÁ COMPLETAMENTE LLENO
		else: # Si no se cumplió lo de arriba, significa que cantidad_actual >= cantidad_maxima
			print("ta lleno - No se puede recoger más")


func accion_de_recogida():
	if get_entidad_aleatoria() != null and jugador.energia_componente.energia > 0 and !cooldown_activo:
				timer.wait_time = cooldown_tiempo
				timer.start()
				cooldown_activo = true
				print("Cooldown activo")
				get_entidad_aleatoria().collect()
				jugador.energia_componente.agotar(1)


func _on_timer_timeout():
	cooldown_activo = false
	print("Cooldown terminado")
