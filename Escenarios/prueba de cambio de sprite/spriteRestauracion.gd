extends Node

@onready var sprite_sucio = $Cesped
@onready var sprite_limpio = $"Cesped Oscuro"
#@onready var sonido_limpieza = $SonidoLimpieza # AudioStreamPlayer, ajustá el path

var porcentaje_actual := 0
var tween_activo: Tween


func _ready() -> void:
	sprite_limpio.modulate.a = 0.0
	SignalBus.zona_limpida.connect(_actualizar_progreso)


func _actualizar_progreso(nuevo_porcentaje: int) -> void:
	porcentaje_actual = nuevo_porcentaje
	_animar_transicion()


func _animar_transicion() -> void:
	if tween_activo and tween_activo.is_valid():
		tween_activo.kill()

	var alpha_objetivo = 1.0 - (float(porcentaje_actual) / 100.0)

	tween_activo = create_tween()
	tween_activo.set_parallel(true)
	tween_activo.tween_property(sprite_sucio, "modulate:a", alpha_objetivo, 0.5)
	tween_activo.tween_property(sprite_limpio, "modulate:a", float(porcentaje_actual) / 100.0, 0.5)

	#if sonido_limpieza and not sonido_limpieza.playing:
	#	sonido_limpieza.play()
