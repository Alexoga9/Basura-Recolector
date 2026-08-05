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
	revisar_espacio_inventario()


func get_entidad_aleatoria() -> Basura:
	if cuerpos.is_empty():
		return null

	var indice = randi() % cuerpos.size() # usa % para conseguir un numero valido 
	return cuerpos[indice]


func revisar_espacio_inventario():
	if Input.is_action_just_pressed("Interaccion"):
		# 1. Obtenemos los datos del ítem "Basura" (puede ser null)
		var recurso_basura = Inventario.get_item_resource("Basura")
		var cantidad_actual = Inventario.get_count("Basura")

		# CASO 1: NO EXISTE LA BASURA EN EL INVENTARIO
		if recurso_basura == null:
			revisar_tipo_de_basura()

		# CASO 2: YA EXISTE LA BASURA, PERO NO ESTÁ LLENO
		elif cantidad_actual < recurso_basura.cantidad_maxima:
			revisar_tipo_de_basura()

		# CASO 3: YA EXISTE LA BASURA Y ESTÁ COMPLETAMENTE LLENO
		else:
			print("ta lleno - No se puede recoger más")


func revisar_tipo_de_basura():
	var body = get_entidad_aleatoria()

	if body != null and jugador.energia_componente.energia > 0 and !cooldown_activo:
		if body.data.veces_a_golpear > 0:
			print("Basura pesada")
			body.romper()

		elif body.data.veces_a_golpear == 0:
			recolectar_basura(body)


func recolectar_basura(basura: Basura):
	timer.wait_time = cooldown_tiempo
	timer.start()
	cooldown_activo = true
	print("Cooldown activo")
	basura.collect()
	jugador.energia_componente.agotar(1)


func click_en_basura(objeto):
	if cuerpos.has(objeto) and jugador.energia_componente.energia > 0 and !cooldown_activo:
		recolectar_basura(objeto)


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
