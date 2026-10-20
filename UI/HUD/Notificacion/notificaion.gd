class_name Notificacion extends Control

var tamaño_viewport: Vector2
@onready var label: Label = %Label
@onready var timer: Timer = %Timer


func _ready():
	tamaño_viewport = get_viewport().size
	tween(-tamaño_viewport.x/2)
	SignalBus.notificacion.connect(tween_entrada)


func recibir_texto(texto: String):
	label.text = texto


func tween(cantidad_deslizar:float):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", (global_position + Vector2(cantidad_deslizar, 0)), 1)\
	.set_ease(Tween.EASE_IN_OUT)\
	.set_trans(Tween.TRANS_QUART)


func tween_entrada(texto: String):
	timer.start()
	show()
	recibir_texto(texto)
	tween(tamaño_viewport.x/2)


func tween_salida():
	tween(tamaño_viewport.x)


func _on_timer_timeout():
	tween_salida()
