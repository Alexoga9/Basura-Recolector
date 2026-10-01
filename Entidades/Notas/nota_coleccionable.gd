extends Area2D

@export var data: DataNotas

@onready var sonido = %sonido
@onready var collision_shape_2d = %CollisionShape2D
@onready var t_deslizar: TDeslizar = %TDeslizar
@onready var sprite_2d: Sprite2D = %Sprite2D

var posicion_anterior: Vector2
var umbral := 0.05 # Distancia mínima para considerar movimiento


func collect():
	collision_shape_2d.call_deferred("set", "disabled", true)
	sprite_2d.visible = false
	sonido.play()


func _on_body_entered(body:Jugador):
	SignalBus.notas_menu.emit(data)
	collect()


func _on_sonido_finished():
	queue_free()
