@icon("res://addons/iconos/basura.svg")
class_name Basura extends RigidBody2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido = %sonido

@export var data: LootDefinicion

var objetivo = null
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


#func _process(delta):
	#if input_recibido:
		#perseguir_jugador(delta)


func recibir_input():
	input_recibido = true
	print("Input recibido")


#func perseguir_jugador(delta):
	#if objetivo != null:
		#global_position = global_position.move_toward(objetivo.global_position, velocidad)
		#velocidad += 2 * delta


func collect():
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	sprite2d.visible = false
	Inventario.add_item(data)
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
	#print(TipoLoot)
	valor = data.valor
#	tags = data.tags
	sonido.stream = data.audio
	sprite2d.texture = data.sprite


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.jugador.recoge_basura.click_en_basura(self)
