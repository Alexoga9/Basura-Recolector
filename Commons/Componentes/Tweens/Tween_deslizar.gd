class_name TDeslizar extends Node2D

# --- VARIABLES EXPORTADAS (Aparecen en el Inspector para ajustarlas fácil) ---
@export var padre: Node2D # El objeto que se va a mover (arrastra tu nodo aquí en el Inspector)
@export var lado: float = 200.0 # Altura del triángulo (desde el pico superior hasta la base)
@export var base_triangulo: float = 300.0 # Ancho total de la base / Diámetro del semicírculo
@export var velocidad_tween: float = 1.0 # Duración del movimiento en segundos

# --- VARIABLES INTERNAS ---
var radio: float
var pico: Vector2
var base_izq: Vector2
var base_der: Vector2
var centro_circulo: Vector2


func _ready():
	# Calculamos los puntos geométricos una sola vez al inicio
	radio = base_triangulo / 2.0
	pico = Vector2(0, 0) # Punta superior
	base_izq = Vector2(-radio, lado) # Esquina inferior izquierda
	base_der = Vector2(radio, lado) # Esquina inferior derecha
	centro_circulo = Vector2(0, lado) # Centro de la base (donde empieza el semicírculo)

	# Dibujamos la forma en pantalla
	queue_redraw()

	# Ejecutamos el primer movimiento (opcional, puedes llamar a esta función cuando quieras)
	tween()


# --- 1. DIBUJO DE LA FORMA ---
func _draw():
	var color_forma = Color(0.8, 0.2, 0.2, 0.4) # Rojo transparente

	# Dibujar el TRIÁNGULO relleno
	draw_colored_polygon(
		PackedVector2Array([pico, base_der, base_izq]),
		color_forma

	)

	# Dibujar el SEMICÍRCULO relleno
	var puntos_arco: PackedVector2Array = []
	var cantidad_puntos: int = 30 # Suavidad del arco

	for i in range(cantidad_puntos + 1):
		var angulo = lerp(0.0, PI, float(i) / float(cantidad_puntos))
		var punto_en_arco = Vector2(cos(angulo) * radio, sin(angulo) * radio)
		puntos_arco.append(centro_circulo + punto_en_arco)

	draw_colored_polygon(puntos_arco, color_forma)

	# Dibujar el BORDE (Opcional, para verlo mejor)
	var color_borde = Color(1, 1, 1, 0.8)
	draw_polyline(PackedVector2Array([pico, base_der, base_izq, pico]), color_borde, 2.0)
	draw_polyline(puntos_arco, color_borde, 2.0)


# --- 2. LÓGICA DE MOVIMIENTO RESTRINGIDO ---
func tween():
	# Si no hay padre asignado, no hacemos nada
	if not padre:
		print("Error: Asigna el nodo 'padre' en el inspector")
		return

	# Generamos un punto aleatorio dentro de la forma usando "Rejection Sampling"
	var destino_local := Vector2.ZERO
	var encontrado := false

	for i in range(20): # Probamos 20 veces a generar un punto dentro
		var x_rand = randf_range(-radio, radio)
		var y_rand = randf_range(0, lado + radio)
		var punto_prueba = Vector2(x_rand, y_rand)

		# Verificar si está dentro del Triángulo
		var en_triangulo = Geometry2D.point_is_inside_triangle(
			punto_prueba,
			pico,
			base_der,
			base_izq

		)

		# Verificar si está dentro del Semicírculo
		var en_circulo = false

		if punto_prueba.y >= lado:
			en_circulo = punto_prueba.distance_to(centro_circulo) <= radio

		# Si está en alguna de las dos zonas, lo aceptamos
		if en_triangulo or en_circulo:
			destino_local = punto_prueba
			encontrado = true
			break

	# Si por casualidad no encontró ningún punto válido (fallback seguro)
	if not encontrado:
		destino_local = Vector2(0, lado) # Se va al centro de la base

	# Calculamos la posición final en el mundo (sumando la posición actual del padre)
	var destino_final = padre.global_position + destino_local

	# Ejecutamos el Tween
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(padre, "position", destino_final, velocidad_tween)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)


# --- 3. (OPCIONAL) Si quieres que se mueva en bucle ---
func _on_timer_timeout():
	# Conecta una señal de Timer a esta función y se moverá infinitamente
	tween()
