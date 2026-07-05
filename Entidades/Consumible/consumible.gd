class_name Consumible extends Area2D

@export var recuperar_energia: int
@onready var sonido = %sonido
@onready var collision_shape_2d = %CollisionShape2D
@onready var sprite_2d = %Sprite2D


func _on_body_entered(body:Jugador):
	body.energia_componente.recuperar(recuperar_energia)
	collect()


func collect():
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	sprite_2d.visible = false


func _on_sonido_finished():
	queue_free()
