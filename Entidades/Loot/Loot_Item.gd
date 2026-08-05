@icon("res://addons/iconos/Loot.svg")
class_name Loot extends Area2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido = %sonido

@export var data: LootDefinicion

var objetivo = null
var input_recibido: bool = false
var velocidad: int = -1

var id: String
var nombre: String
enum TipoBasura {BASICO, PESADO}
var tipo_de_basura: TipoBasura
var valor: int


func _ready():
	iniciar_valores()


func iniciar_valores():
	id = data.id
	nombre = data.nombre
	tipo_de_basura = int(data.tipo_de_basura)
	valor = data.valor
	sonido.stream = data.audio
	sprite2d.texture = data.sprite


func collect():
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	sprite2d.visible = false
	return data


func _on_area_entered(area):
	if area.is_in_group("Radar_Loot"):
		objetivo = area


func _on_sonido_finished():
	queue_free()
