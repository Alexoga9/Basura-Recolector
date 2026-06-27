@icon("res://addons/iconos/Movimiento.svg")
class_name MovimientoComponente extends Node

enum TipoCuerpo {CHARACTER_BODY, AREA}
@export var tipo_cuerpo: TipoCuerpo = TipoCuerpo.CHARACTER_BODY

@export_category("Movimiento")
@export var velocidad_movimiento: float = 40.0
@export var velocidad_rotacion: float = (TAU * 2)
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@export_category("Referencias")
@export var body_character: CharacterBody2D
@export var body: Node2D
@export var sprite: Sprite2D

var ultimo_movimiento = Vector2.RIGHT


func _validate_property(property: Dictionary):
	# Ocultar/mostrar propiedades según el tipo de cuerpo seleccionado
	match property.name:
		"body_character":
			if tipo_cuerpo != TipoCuerpo.CHARACTER_BODY:
				property.usage = 0 # PROPERTY_USAGE_NO_EDITOR

		"body":
			if tipo_cuerpo != TipoCuerpo.AREA:
				property.usage = 0


func movimiento(direccion: Vector2, delta: float):
	# Actualizar sprite
	if animated_sprite_2d:
		if direccion.x > 0:
			animated_sprite_2d.flip_h = false
		elif direccion.x < 0:
			animated_sprite_2d.flip_h = true

	if animated_sprite_2d:
		if direccion != Vector2.ZERO:
			animated_sprite_2d.play("Walk")
		else:
			animated_sprite_2d.play("Idle")

	# Guardar último movimiento válido
	if direccion != Vector2.ZERO:
		ultimo_movimiento = direccion

	# Aplicar movimiento según el tipo de cuerpo
	match tipo_cuerpo:
		TipoCuerpo.CHARACTER_BODY:
			mover_character_body(direccion)

		TipoCuerpo.AREA:
			mover_con_delta(direccion, delta)


func mover_character_body(direccion: Vector2):
	if body_character:
		body_character.velocity = direccion.normalized() * velocidad_movimiento
		body_character.move_and_slide()


# Para usar con las areas
func mover_con_delta(direccion: Vector2, delta: float):
	if tipo_cuerpo == TipoCuerpo.AREA and body:
		body.position += direccion.normalized() * velocidad_movimiento * delta
		body.rotation = rotate_toward(body.rotation,
			direccion.angle(),
			velocidad_rotacion * delta)
