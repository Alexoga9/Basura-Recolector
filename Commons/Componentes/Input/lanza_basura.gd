@icon("res://addons/iconos/lanzar.svg")
class_name LanzaBasura extends Node

@export var bolsa_de_basura: PackedScene
@export var data: LootDefinicion

@export var fuerza_lanzamiento: float = 100.0
@export var distancia_vuelo: float = 50.0
@export var offset_inicial: float = 30.0

@onready var jugador: Jugador = $"../.."

var direccion_lanzamiento: Vector2 = Vector2.UP


func _process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector(
		"izquierda",
		"derecha",
		"arriba",
		"abajo"

	)

	if input_dir != Vector2.ZERO:
		direccion_lanzamiento = input_dir.normalized()

	if Input.is_action_just_pressed("Lanzar_Basura"):
		lanzar_basura()


func lanzar_basura() -> void:
	if Inventario.peso <= 0:
		return

	if bolsa_de_basura == null or data == null:
		push_warning("Falta configurar la bolsa de basura.")
		return

	# Crear datos independientes para la bolsa.
	var datos_bolsa: LootDefinicion = data.duplicate()
	datos_bolsa.valor = Inventario.valor_de_basuras

	# Crear y lanzar la bolsa.
	if spawnear(datos_bolsa):
		Inventario.peso = 0
		Inventario.valor_de_basuras = 0


func spawnear(datos_bolsa: LootDefinicion) -> bool:
	if fuerza_lanzamiento <= 0.0:
		return false

	if not is_instance_valid(jugador):
		return false

	var nuevo: BolsaDeBasura = bolsa_de_basura.instantiate() as BolsaDeBasura

	if nuevo == null:
		push_warning("La escena debe utilizar BolsaDeBasura como script raíz.")
		return false

	# Asignar datos ANTES de agregar al árbol.
	nuevo.data = datos_bolsa

	get_tree().current_scene.add_child(nuevo)

	# Posición inicial frente al jugador.
	var direccion: Vector2 = direccion_lanzamiento.normalized()

	var posicion_inicial: Vector2 = (
		jugador.global_position +
		direccion * offset_inicial

	)

	nuevo.global_position = posicion_inicial

	# La distancia representa cuánto viaja después de aparecer.
	var punto_final: Vector2 = (
		posicion_inicial +
		direccion * distancia_vuelo

	)

	var tiempo_vuelo: float = distancia_vuelo / fuerza_lanzamiento

	var tween: Tween = nuevo.create_tween()

	tween.tween_property(
		nuevo,
		"global_position",
		punto_final,
		tiempo_vuelo

	).set_trans(Tween.TRANS_LINEAR)

	return true
