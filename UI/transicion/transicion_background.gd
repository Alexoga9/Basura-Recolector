extends Control

@onready var color_rect: ColorRect = %ColorRect
var transicion_activa: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	animar_transicion(delta)


func animar_transicion(delta: float):
	if !transicion_activa:
		return

	var shader_value = color_rect.material.get_instance_shader_parameter("progress")
	shader_value += delta * 0.01
	shader_value = clamp(shader_value, 0.0, 1.0)
	material.set_instance_shader_parameter("progress", shader_value)
