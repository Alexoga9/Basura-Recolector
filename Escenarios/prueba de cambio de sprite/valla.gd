class_name pueta_valla extends StaticBody2D

@onready var vallatext: Label = %vallatext
@onready var area_deteccion = %"Trigger Jugador"
@onready var APuerta: AnimatedSprite2D = %puerta
@export var porcentaje_requerido: int = 80
@export var next_scene: String
@export var costo_puerta: int = 500

enum Condiccion_para_abrir {Abierta, Requisito}

@export var condiccion_para_abrir: Condiccion_para_abrir
var jugador_cerca: bool = false
static var porcentaje_actual: int = 0
var timer_mensaje: Timer


func _ready() -> void:
	# Escuchamos el progreso y el botón de interacción

	Global.jugador.contador_componente.limpieza_actualizada.connect(_actualizar_progreso)
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

	# aplicar que si no tiene el dinero suficiente y/o pago pueda abrir la puerta
	if condiccion_para_abrir == Condiccion_para_abrir.Requisito:
		if porcentaje_actual >= porcentaje_requerido:
			abrir_paso()
			deducción_de_costo()
		else:
			vallatext.show()
			vallatext.text = "Tienes que limpiar el " + str(porcentaje_requerido) +" % "
			print(str(porcentaje_actual))
	elif condiccion_para_abrir == Condiccion_para_abrir.Abierta:
		abrir_paso()


func deducción_de_costo():
	Dinero.gastar(float(costo_puerta))


func back() -> void:
	Global.jugador.contador_componente.limpieza_actualizada.disconnect(_actualizar_progreso)
	SignalBus.interaccion.disconnect(_al_interactuar)
	APuerta.play("puerta_abierta")
	$CollisionShape2D.disabled = true
	get_tree().change_scene_to_file(next_scene)
	SaveGame.Load_Game()


func abrir_paso() -> void:
	Global.jugador.contador_componente.limpieza_actualizada.disconnect(_actualizar_progreso)
	SignalBus.interaccion.disconnect(_al_interactuar)
	APuerta.play("puerta_abierta")
	$CollisionShape2D.disabled = true
	get_tree().change_scene_to_file(next_scene)
	SaveGame.Save_Game()
