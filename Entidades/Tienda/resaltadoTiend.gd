extends Node

@export var material: Material

@export var e_sprite: AnimatedSprite2D


func _ready():
	outline_off()
	ocutlar_e()


func outline_on():
	get_parent().material = material


func outline_off():
	get_parent().material = null


func mostrar_e():
	if e_sprite != null:
		e_sprite.visible = true


func ocutlar_e():
	if e_sprite != null:
		e_sprite.visible = false


func _on_trigger_jugador_body_entered(body):
	outline_on()
	mostrar_e()


func _on_trigger_jugador_body_exited(body):
	outline_off()
	ocutlar_e()
