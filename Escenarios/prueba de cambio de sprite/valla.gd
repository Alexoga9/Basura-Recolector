extends StaticBody2D

@onready var mensaje = %msj
@onready var area_deteccion = %Area2D

@export var porcentaje_requerido: int = 80


func _ready() -> void:
	mensaje.visible = false
	mensaje.text = "¡Limpia el " + str(porcentaje_requerido) + "% para pasar!"

	area_deteccion.body_entered.connect(_al_acercarse)
	area_deteccion.body_exited.connect(_al_alejarse)

	# Nos conectamos a la nueva señal de progreso
	SignalBus.zona_limpida.connect(_verificar_progreso)


func _al_acercarse(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		mensaje.visible = true


func _al_alejarse(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		mensaje.visible = false


# Esta función se llama CADA VEZ que el jugador recoge una basura
func _verificar_progreso(porcentaje_actual: int) -> void:
	if porcentaje_actual >= porcentaje_requerido:
		abrir_paso()


func abrir_paso() -> void:
	SignalBus.zona_limpida.disconnect(_verificar_progreso)

	queue_free()
