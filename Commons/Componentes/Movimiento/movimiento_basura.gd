class_name MovimientoBasura extends Node

@export var basura: PackedScene
@onready var mov_componente:MovimientoComponente = %MovimientoComponente
@onready var timer:Timer = %Timer

var dirección: Vector2
var tiempo_viaje: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tiempo_viaje:
		mov_componente.movimiento(dirección, delta)


func _on_timer_timeout():
	tiempo_viaje = false
