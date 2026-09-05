extends StaticBody2D

@onready var vallatext: Label = %vallatext
@onready var area_deteccion = %"Trigger Jugador"
@onready var APuerta: AnimatedSprite2D = %puerta
@export var porcentaje_requerido: int = 80

var jugador_cerca: bool = false
var porcentaje_actual: int = 0
var timer_mensaje: Timer


func _ready() -> void:
	# Escuchamos el progreso y el botón de interacción
	SignalBus.zona_limpida.connect(_actualizar_progreso)
	SignalBus.interaccion.connect(_al_interactuar)

	vallatext.hide()


func _on_trigger_jugador_body_entered(body: Node2D) -> void:
	_al_acercarse(body)


func _on_trigger_jugador_body_exited(body: Node2D) -> void:
	_al_alejarse(body)


func _al_acercarse(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_cerca = true


func _al_alejarse(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		jugador_cerca = false
		vallatext.hide()


func _actualizar_progreso(nuevo_porcentaje: int) -> void:
	porcentaje_actual = nuevo_porcentaje


func _al_interactuar() -> void:
	if not jugador_cerca:
		return

	if porcentaje_actual >= porcentaje_requerido:
		abrir_paso()
	else:
		vallatext.show()
		vallatext.text = "Tienes que limpiar el " + str(porcentaje_requerido) +" % "


func abrir_paso() -> void:
	SignalBus.zona_limpida.disconnect(_actualizar_progreso)
	SignalBus.interaccion.disconnect(_al_interactuar)
	APuerta.play("puerta_abierta")
	$CollisionShape2D.disabled = true
