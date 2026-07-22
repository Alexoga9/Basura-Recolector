@icon("res://addons/iconos/basura.svg")
class_name Basura extends StaticBody2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido = %sonido
@onready var resaltado_componente: ResaltadoComponente = %ResaltadoComponente
@onready var t_recogida: TRecogida = %TRecogida
@onready var ray_cast_2d: RayCast2D = %RayCast2D

@export var data: LootDefinicion

var objetivo = null
var en_area_jugador: bool = false
var input_recibido: bool = false
var velocidad: int = -1

var id: String
var nombre: String
enum TipoBasura {BASICO, PESADO, PAQUETE}
var tipo_de_basura: TipoBasura
var valor: int
var tags: String


func _ready():
	iniciar_valores()
	SignalBus.recoger_basura_automatica.connect(recibir_input)


func recibir_input():
	input_recibido = true


func collect():
	t_recogida.tween()
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)

	Inventario.add_item(data)
	#sprite2d.visible = false
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
#	tags = data.tags
	sonido.stream = data.audio
	sprite2d.texture = data.sprite


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.jugador.recoge_basura.click_en_basura(self)


func apilar_basura():
	var objeto
	ray_cast_2d.collide_with_bodies
	objeto = ray_cast_2d.is_colliding()

	if objeto == Basura:
		z_index = objeto.z_index + 1
		collision_shape_2d.disabled = true

	else:
		z_index = 0
		collision_shape_2d.disabled = false
