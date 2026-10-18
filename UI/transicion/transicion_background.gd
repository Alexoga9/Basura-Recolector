extends Control

@onready var color_rect: ColorRect = %ColorRect
var transicion_activa: bool = false


func _ready():
	color_rect.material.set_shader_parameter("progress", 1)
	SignalBus.hacer_transicion.connect(recibido_transicion)
	hide()


func _physics_process(delta):
	animar_transicion(delta)


func recibido_transicion():
	transicion_activa = true


func animar_transicion(delta: float):

	if not transicion_activa:
		return

	show()
	var shader_value = color_rect.material.get_shader_parameter("progress")
	shader_value -= delta
	shader_value = clamp(shader_value, 0.0, 1.0)
	color_rect.material.set_shader_parameter("progress", shader_value)
	if shader_value == 0:
		resetear_transicion()
		SignalBus.terminar_transicion.emit()


func resetear_transicion():
	hide()
	transicion_activa = false
	var shader_value = color_rect.material.get_shader_parameter("progress")
	shader_value = 1
	shader_value = clamp(shader_value, 0.0, 1.0)
	color_rect.material.set_shader_parameter("progress", shader_value)
