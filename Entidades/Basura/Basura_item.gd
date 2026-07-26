@icon("res://addons/iconos/basura.svg")
class_name Basura extends StaticBody2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido = %sonido
@onready var resaltado_componente: ResaltadoComponente = %ResaltadoComponente
@onready var t_recogida: TRecogida = %TRecogida
@onready var ray_cast_abajo: RayCast2D = %RayCast2D
@onready var ray_cast_arriba: RayCast2D = %RayCastArriba

@export var data: LootDefinicion

var objetivo = null
var en_area_jugador: bool = false
var input_recibido: bool = false

var id: String
var nombre: String
enum TipoBasura {BASICO, PESADO, PAQUETE}
var tipo_de_basura: TipoBasura
var valor: int

# 📌 Variables de apilamiento
var caja_debajo: StaticBody2D = null
var caja_arriba: StaticBody2D = null
var cayendo: bool = false
var altura_pila: int = 0


func _ready():
	iniciar_valores()
	SignalBus.recoger_basura_automatica.connect(recibir_input)

	# Configuramos los raycasts
	ray_cast_abajo.enabled = true
	ray_cast_arriba.enabled = true

	# Detectamos estado inicial
	detectar_caja_debajo()
	detectar_caja_arriba()


func _process(delta):
	# Si no estamos cayendo y no hay caja debajo, caemos
	if not cayendo and caja_debajo == null and altura_pila > 0:
		caer_al_siguiente_nivel()


func recibir_input():
	input_recibido = true


func collect():
	t_recogida.tween()
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)

	Inventario.add_item(data)
	SignalBus.basura_recogida.emit()
	return data


func _on_area_entered(area):
	if area.is_in_group("Radar_Loot"):
		objetivo = area


func _on_sonido_finished():
	queue_free()


func iniciar_valores():
	id = data.id
	nombre = data.nombre
	tipo_de_basura = int(data.tipo_de_basura)
	valor = data.valor
	sonido.stream = data.audio
	sprite2d.texture = data.sprite

	detectar_caja_debajo()
	detectar_caja_arriba()


# 📌 DETECCIÓN DE CAJA DEBAJO (abajo)
func detectar_caja_debajo():
	ray_cast_abajo.force_raycast_update()

	if ray_cast_abajo.is_colliding():
		var colision = ray_cast_abajo.get_collider()

		if colision != self and colision is StaticBody2D:
			caja_debajo = colision

			if caja_debajo.has_method("get_altura_pila"):
				altura_pila = caja_debajo.get_altura_pila() + 1
			else:
				altura_pila = 1

			z_index = caja_debajo.z_index + 1
			return

	caja_debajo = null
	altura_pila = 0
	z_index = 0


# 📌 DETECCIÓN DE CAJA ARRIBA (arriba) - ¡LA CLAVE PARA LA CADENA!
func detectar_caja_arriba():
	ray_cast_arriba.force_raycast_update()

	if ray_cast_arriba.is_colliding():
		var colision = ray_cast_arriba.get_collider()

		if colision != self and colision is StaticBody2D:
			caja_arriba = colision
			return

	caja_arriba = null


# 📌 CAÍDA
func caer_al_siguiente_nivel():
	if cayendo:
		return

	cayendo = true

	# Animación de caída (ajusta el 32 a tu tile)
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y + 5), 0.1)

	tween.tween_callback(func():
		cayendo = false

		# 📌 PASO CRUCIAL: Cuando caemos, avisamos a la caja de arriba
		if caja_arriba != null:
			if caja_arriba.has_method("detectar_caja_debajo"):
				caja_arriba.detectar_caja_debajo()

		# Volvemos a detectar qué hay debajo (y si hay arriba)
		detectar_caja_debajo()
		detectar_caja_arriba()

	)


func get_altura_pila() -> int:
	return altura_pila


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.jugador.recoge_basura.click_en_basura(self)
