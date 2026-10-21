@icon("res://addons/iconos/Movimiento.svg")
class_name MovimientoComponente extends Node

enum TipoCuerpo {CHARACTER_BODY, AREA}
@export var tipo_cuerpo: TipoCuerpo = TipoCuerpo.CHARACTER_BODY

@export_category("Movimiento")
@export var velocidad_movimiento: float = 40.0
@export var aceleracion: float = 12.5
@export var friccion: float = 4.5
@export var velocidad_rotacion: float = (TAU * 2)

var ultima_direccion: Vector2 = Vector2.DOWN

@export_category("Animaciones de correr")
@export var correr_derecha: StringName = &"Run_right"
@export var correr_izquierda: StringName = &"Run_left"
@export var correr_abajo: StringName = &"Run_down"
@export var correr_arriba: StringName = &"Run_up"

@export_category("Referencias")
@export var body_character: CharacterBody2D
@export var body: Node2D
@export var sprite: Sprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
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
	# Elegir un solo eje para impedir el movimiento diagonal.
	if abs(direccion.x) >= abs(direccion.y):
		direccion = Vector2(sign(direccion.x), 0)
	else:
		direccion = Vector2(0, sign(direccion.y))

	if direccion != Vector2.ZERO:
		ultima_direccion = direccion
		ultimo_movimiento = direccion

	if animated_sprite_2d:
		animated_sprite_2d.flip_h = false
		var animacion_idle: StringName
		var animacion_correr: StringName
		if ultima_direccion.x != 0:
			if ultima_direccion.x > 0:
				animacion_idle = &"Idle_right"
				animacion_correr = correr_derecha
			else:
				animacion_idle = &"Idle_left"
				animacion_correr = correr_izquierda
		else:
			if ultima_direccion.y > 0:
				animacion_idle = &"Idle_down"
				animacion_correr = correr_abajo
			else:
				animacion_idle = &"Idle_up"
				animacion_correr = correr_arriba
		var animacion: StringName = animacion_idle
		if direccion != Vector2.ZERO and animated_sprite_2d.sprite_frames.has_animation(animacion_correr):
			animacion = animacion_correr
		animated_sprite_2d.play(animacion)

	# Aplicar movimiento según el tipo de cuerpo
	match tipo_cuerpo:
		TipoCuerpo.CHARACTER_BODY:
			mover_character_body(direccion, delta)

		TipoCuerpo.AREA:
			mover_con_delta(direccion, delta)


func mover_character_body(direccion: Vector2, delta:float):
	if body_character:
		# Eliminar la inercia perpendicular al cambiar de eje.
		if direccion.x != 0:
			body_character.velocity.y = 0
		elif direccion.y != 0:
			body_character.velocity.x = 0
		var peso_de_velocidad: float = clampf(delta * (aceleracion if direccion else friccion), 0.0, 1.0)
		body_character.velocity = lerp(body_character.velocity, (direccion.normalized() * velocidad_movimiento), peso_de_velocidad)
		body_character.move_and_slide()


# Para usar con las areas
func mover_con_delta(direccion: Vector2, delta: float):
	if tipo_cuerpo == TipoCuerpo.AREA and body:
		body.position += direccion.normalized() * velocidad_movimiento * delta
		body.rotation = rotate_toward(body.rotation,
			direccion.angle(),
			velocidad_rotacion * delta)
