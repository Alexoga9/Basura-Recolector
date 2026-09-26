class_name Restauracion extends Node

@onready var sprite_sucio = %"Map Oscuro"
@onready var sprite_limpio = $Cesped

# @onready var sonido_limpieza = $SonidoLimpieza
 
var porcentaje_actual: int
var tween_activo: Tween
var ya_flasheo := false  
const UMBRAL_FLASH := 100
 
# RECORDAR QUE SI CAMBIAS LA VARIABLE porcentaje_actual tambien tienes que cambiar UMBRAL_FLASH


func _ready() -> void:
	sprite_limpio.hide()
	SignalBus.zona_limpida.connect(actualizar_porcentaje)

	# Asigna el shader a ambos sprites (o hazlo desde el editor y quita estas 2 líneas)
	sprite_sucio.material = ShaderMaterial.new()
	sprite_sucio.material.shader = preload("res://Escenarios/shine/hit_flash.gdshader")
	sprite_limpio.material = ShaderMaterial.new()
	sprite_limpio.material.shader = preload("res://Escenarios/shine/hit_flash.gdshader")


func actualizar_porcentaje(porcentaje: int) -> void:
	porcentaje_actual = porcentaje


func _process(delta: float) -> void:
	if porcentaje_actual >= UMBRAL_FLASH:
		flashing()


func flashing()-> void:
	if porcentaje_actual >= UMBRAL_FLASH and not ya_flasheo:
		ya_flasheo = true
		_animar_transicion()
		_hit_flash()
		sprite_limpio.show()
		sprite_sucio.hide()
	elif porcentaje_actual < UMBRAL_FLASH:
		ya_flasheo = false


func _animar_transicion() -> void:
	if tween_activo and tween_activo.is_valid():
		tween_activo.kill()

	tween_activo = create_tween()
	tween_activo.set_parallel(true)
	tween_activo.tween_property(sprite_sucio, "modulate:a", 00, 0.5)
	tween_activo.tween_property(sprite_limpio, "modulate:a", 1, 1)


func _hit_flash() -> void:
	var flash_tween = create_tween()
	flash_tween.tween_method(_set_flash_amount, 0.0, 1.0, 0.08)
	flash_tween.tween_method(_set_flash_amount, 1.0, 0.0, 0.15)


func _set_flash_amount(valor: float) -> void:
	sprite_sucio.material.set_shader_parameter("flash_amount", valor)
	sprite_limpio.material.set_shader_parameter("flash_amount", valor)
