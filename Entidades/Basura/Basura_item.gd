@icon("res://addons/iconos/basura.svg")
class_name Basura extends StaticBody2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido: AudioStreamPlayer = %sonido_recogida
@onready var sonido_romper: AudioStreamPlayer = %sonido_romper

@onready var resaltado_componente: ResaltadoComponente = %ResaltadoComponente
@onready var t_recogida: TRecogida = %TRecogida
@onready var tween_rebote:TweenRebote = %TweenRebote

# 📌 EL COMPONENTE DE APILAMIENTO
@onready var componente_apilable: ComponenteApilable = %ComponenteApilable

@export var data: LootDefinicion

var objetivo = null
var en_area_jugador: bool = false
var input_recibido: bool = false

var id: String
var nombre: String
var valor: int

enum TipoBasura {BASICO, PESADO, PAQUETE}
var tipo_de_basura: TipoBasura

enum tipo_de_requisito_Enum {RECOGIDA, FUERZA}
var tipo_de_requisito: tipo_de_requisito_Enum

enum TipoElemento {BASURA,
OBSTACULO,
}
var tipo_de_elemento: TipoElemento


func _ready():
	iniciar_valores()
	SignalBus.interaccion.connect(recibir_input)


func iniciar_valores():
	id = data.id
	nombre = data.nombre
	tipo_de_basura = int(data.tipo_de_basura)
	tipo_de_requisito = int(data.tipo_de_requisito)
	tipo_de_elemento = int(data.tipo_de_elemento)
	valor = data.valor
	sonido.stream = data.audio
	sprite2d.texture = data.sprite


func grupo():
	match tipo_de_elemento:
		TipoElemento.BASURA:
			self.add_to_group("Basura")

		TipoElemento.OBSTACULO:
			self.add_to_group("Obstaculo")


func recibir_input():
	input_recibido = true


func collect():
	t_recogida.tween()
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)

	Inventario.add_item(data)
	SignalBus.basura_recogida.emit()
	return data


func romper():
	data.veces_a_golpear -= 1
	sonido_romper.play()
	tween_rebote.tween()


func _on_sonido_finished():
	queue_free()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.jugador.recoge_basura.click_en_basura(self)


#func detectar_colision():
	#
