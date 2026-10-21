@icon("res://addons/iconos/obstaculo.svg")
class_name BolsaDeBasura extends AnimatableBody2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido = %sonido
@onready var resaltado_componente: ResaltadoComponente = %ResaltadoComponente
@onready var t_recogida: TRecogida = %TRecogida

@export var data: LootDefinicion

var objetivo = null
var en_area_jugador: bool = false
var input_recibido: bool = false

var peso_contenido: int = 1
var puede_recogerse: bool = true
var recogida: bool = false

var id: String
var nombre: String
var requisito: bool
enum tipo_de_requisito_Enum {RECOGIDA, FUERZA}
var tipo_de_requisito: tipo_de_requisito_Enum
var nivel_requisito: int
var valor: int


func _ready():
	iniciar_valores()


func collect() -> LootDefinicion:
	if not puede_recogerse or recogida:
		return null

	if data == null:
		return null

	recogida = true
	puede_recogerse = false

	t_recogida.tween()
	sonido.play()

	collision_shape_2d.set_deferred("disabled", true)

	Inventario.peso += peso_contenido
	Inventario.valor_de_basuras += data.valor

	SignalBus.basura_recogida.emit()

	return data


func triturar() -> bool:
	if recogida or is_queued_for_deletion() or data == null:
		return false

	# Consumir la bolsa sin devolver su contenido al inventario.
	recogida = true
	puede_recogerse = false
	collision_shape_2d.set_deferred("disabled", true)
	queue_free()
	return true


func _on_sonido_finished():
	queue_free()


func iniciar_valores() -> void:
	if data == null:
		push_warning("La bolsa de basura no tiene datos asignados.")
		return

	id = data.id
	nombre = data.nombre
	requisito = data.tiene_requisito
	tipo_de_requisito = int(data.tipo_de_requisito)
	nivel_requisito = data.nivel_de_requisito
	valor = data.valor

	sonido.stream = data.audio
	sprite2d.texture = data.sprite


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.jugador.radar_componente.click_en_basura(self)
