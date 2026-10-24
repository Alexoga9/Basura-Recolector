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
var recogido: bool = false


func _ready():
	iniciar_valores()
	input_event.connect(_on_input_event)


func iniciar_valores():
	id = data.id
	nombre = data.nombre
	tipo_de_basura = int(data.tipo_de_basura)
	valor = data.valor
	sonido.stream = data.audio
	sprite2d.texture = data.sprite


func collect():
	if recogido:
		return null

	recogido = true
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	sprite2d.visible = false
	SignalBus.material_recogido.emit()
	if sonido.stream == null:
		queue_free()

	return data


func es_coleccionable() -> bool:
	return data != null and data.tipo_de_elemento == LootDefinicion.TipoElemento.COLECCIONABLE


func _on_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not recogido or Interfaces.juego_bloqueado():
		return

	if not (event is InputEventMouseButton):
		return

	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	var jugador := Global.jugador

	if not is_instance_valid(jugador):
		return

	if not jugador.radar_componente.get_overlapping_areas().has(self):
		return

	if Inventario.get_count(data.id) >= data.cantidad_maxima:
		return

	Inventario.add_item(data)
	collect()
	jugador.mostrar_recogida(nombre)
	viewport.set_input_as_handled()


func _on_area_entered(area):
	if area.is_in_group("Radar_Loot"):
		objetivo = area


func _on_sonido_finished():
	queue_free()
