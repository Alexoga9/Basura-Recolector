class_name LanzaBasura extends Node

@export var bolsa_de_basura: PackedScene
@export var data_template: LootDefinicion

var direccion_lanzamiento: Vector2 = Vector2.UP
@export var fuerza_lanzamiento: float = 100.0 # Velocidad de vuelo (píxeles por segundo)
@export var distancia_vuelo: float = 50.0 # Qué tan lejos volará antes de desaparecer o chocar


func _process(delta):
	var input_dir = Input.get_vector("izquierda", "derecha", "arriba", "abajo")

	if input_dir != Vector2.ZERO:
		direccion_lanzamiento = input_dir

	if Input.is_action_just_pressed("Lanzar_Basura"):
		datos_basura()


func datos_basura():
	if Inventario.get_count("Basura") == null or Inventario.get_count("Basura") <= 0:
		return

	var cantidad_basura: int = Inventario.get_count("Basura")
	var recurso_basura = Inventario.get_item_resource("Basura")

	if recurso_basura == null:
		return

	var valor_total: int = cantidad_basura * recurso_basura.valor

	var datos_bolsa = data_template.duplicate()
	datos_bolsa.valor = valor_total

	Inventario.remove_item("Basura", cantidad_basura)
	spawnear(datos_bolsa)


func spawnear(datos_bolsa: LootDefinicion):
	var nuevo = bolsa_de_basura.instantiate()
	nuevo.data = datos_bolsa

	# Posición inicial: Justo delante del jugador
	var posicion_inicial = $"..".global_position
	var offset_inicial: float = 30.0 # Para que no explote dentro del jugador
	nuevo.global_position = posicion_inicial + (direccion_lanzamiento * offset_inicial)

	# Agregamos la bolsa al mundo
	get_tree().current_scene.add_child(nuevo)

	# 👇 AQUÍ ESTÁ EL MOVIMIENTO LINEAL, TOTALMENTE CONTROLADO AQUÍ 👇
	var punto_final = posicion_inicial + (direccion_lanzamiento * distancia_vuelo)

	# Calculamos el tiempo que tardará en llegar según la fuerza de lanzamiento
	var tiempo_vuelo = distancia_vuelo / fuerza_lanzamiento

	# Crear el Tween para mover la bolsa suavemente
	var tween = create_tween()
	tween.tween_property(nuevo, "global_position", punto_final, tiempo_vuelo)\
	.set_trans(Tween.TRANS_LINEAR)\
	.set_ease(Tween.EASE_OUT)
