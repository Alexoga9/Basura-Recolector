@icon("res://addons/iconos/chocolate.svg")
class_name Consumible extends Area2D

@export var data: DataConsumible
@onready var sonido = %sonido
@onready var collision_shape_2d = %CollisionShape2D
@onready var sprite_2d = %Sprite2D
@onready var animacion = %AnimatedSprite2D
@onready var t_deslizar: TDeslizar = %TDeslizar

var posicion_anterior: Vector2
var umbral := 0.05 # Distancia mínima para considerar movimiento


func _ready():
	sprite_aleatorio()


func _process(delta):
	detener_animacion()
	posicion_anterior = global_position


func sprite_aleatorio():
	var random: int = randi_range(0,2)
	animacion.sprite_frames = data.conjunto_de_sprites

	var numero_de_animaciones = data.conjunto_de_sprites.get_animation_names()
	var aleatoria = numero_de_animaciones[randi() % numero_de_animaciones.size()]

	if data.conjunto_de_sprites:
		animacion.animation = aleatoria
		animacion.play()


func detener_animacion():
	if global_position.distance_to(posicion_anterior) < umbral:
		animacion.stop()


func collect():
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	animacion.visible = false
	print("RECUPERO " + str(data.recuperar_energia))


func _on_body_entered(body:Jugador):
	body.energia_componente.recuperar(data.recuperar_energia)
	collect()


func _on_sonido_finished():
	queue_free()
