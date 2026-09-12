extends Node

@onready var sprite_sucio = $Cesped
@onready var sprite_limpio = $"Cesped Oscuro"
#@onready var sonido_limpieza = $SonidoLimpieza

var porcentaje_actual := 0
var tween_activo: Tween
var ya_flasheo := false  # evita que se repita en cada frame sobre 80%

const UMBRAL_FLASH := 80


func _ready() -> void:
	sprite_limpio.modulate.a = 0.0
#	Global.jugador.contador_componente.limpieza_actualizada.connect(_actualizar_progreso)

	# Asigna el shader a ambos sprites (o hazlo desde el editor y quita estas 2 líneas)
	sprite_sucio.material = ShaderMaterial.new()
	sprite_sucio.material.shader = preload("res://Escenarios/shine/hit_flash.gdshader")
	sprite_limpio.material = ShaderMaterial.new()
	sprite_limpio.material.shader = preload("res://Escenarios/shine/hit_flash.gdshader")


func _actualizar_progreso(nuevo_porcentaje: int) -> void:
	porcentaje_actual = nuevo_porcentaje
	_animar_transicion()

	if porcentaje_actual >= UMBRAL_FLASH and not ya_flasheo:
		ya_flasheo = true
		_hit_flash()
	elif porcentaje_actual < UMBRAL_FLASH:
		ya_flasheo = false # permite que vuelva a flashear si baja y sube de nuevo


func _animar_transicion() -> void:
	if tween_activo and tween_activo.is_valid():
		tween_activo.kill()

	var alpha_objetivo = 1.0 - (float(porcentaje_actual) / 100.0)
	tween_activo = create_tween()
	tween_activo.set_parallel(true)
	tween_activo.tween_property(sprite_sucio, "modulate:a", alpha_objetivo, 0.5)
	tween_activo.tween_property(sprite_limpio, "modulate:a", float(porcentaje_actual) / 100.0, 0.5)


func _hit_flash() -> void:
	var flash_tween = create_tween()
	flash_tween.tween_method(_set_flash_amount, 0.0, 1.0, 0.08)
	flash_tween.tween_method(_set_flash_amount, 1.0, 0.0, 0.15)


func _set_flash_amount(valor: float) -> void:
	sprite_sucio.material.set_shader_parameter("flash_amount", valor)
	sprite_limpio.material.set_shader_parameter("flash_amount", valor)
