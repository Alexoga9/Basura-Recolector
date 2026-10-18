class_name pueta_valla extends StaticBody2D

@onready var vallatext: Label = %vallatext
@onready var area_deteccion = %"Trigger Jugador"
@onready var APuerta: AnimatedSprite2D = %puerta

@export var porcentaje_requerido: int = 80
@export var next_scene: String
@export var costo_puerta: int = 500
@export var entrada_posicion: int
enum Condiccion_para_abrir {Abierta, Requisito}

@export var condiccion_para_abrir: Condiccion_para_abrir
var jugador_cerca: bool = false
static var porcentaje_actual: int = 0
var timer_mensaje: Timer


func _ready() -> void:
	# Escuchamos el progreso y el botón de interacción
	SignalBus.zona_limpida.connect(_actualizar_progreso)
	SignalBus.interaccion.connect(_al_interactuar)
	SignalBus.pasar_entrada_valla.connect(pasar_puerta)

	vallatext.hide()
	iniciar_sprite()


func iniciar_sprite():
	if condiccion_para_abrir == Condiccion_para_abrir.Abierta:
		APuerta.play("puerta_abierta")


# ------------------------------------------------------------------
# Guardado / carga (lo usan RecolectorData y ReconstructorData)
# ------------------------------------------------------------------
func serializar_estado() -> Dictionary:
	return {
		"porcentaje_requerido": porcentaje_requerido,
		"next_scene": next_scene,
		"costo_puerta": costo_puerta,
		"entrada_posicion": entrada_posicion,
		"condiccion_para_abrir": condiccion_para_abrir,
	}


func restaurar_estado(d: Dictionary) -> void:
	porcentaje_requerido = d.get("porcentaje_requerido", porcentaje_requerido)
	next_scene = d.get("next_scene", next_scene)
	costo_puerta = d.get("costo_puerta", costo_puerta)
	entrada_posicion = d.get("entrada_posicion", entrada_posicion)
	condiccion_para_abrir = d.get("condiccion_para_abrir", condiccion_para_abrir)


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
			deducción_de_costo()
		else:
			vallatext.show()
			vallatext.text = "Tienes que limpiar el " + str(porcentaje_requerido) + " % " + " y tener " + str(costo_puerta) + " monedas"
			print(str(porcentaje_actual))
	elif condiccion_para_abrir == Condiccion_para_abrir.Abierta:
		preguntar_puerta()


func deducción_de_costo() -> void:
	# antes era '<=': con dinero exacto no dejaba pagar

	if Dinero.dinero < costo_puerta:
		return

	Dinero.gastar(float(costo_puerta))
	abrir_paso()


func abrir_paso() -> void:
	condiccion_para_abrir = Condiccion_para_abrir.Abierta
	# is_connected evita error si ya estaba desconectado
	var contador = Global.jugador.contador_componente

	if contador.limpieza_actualizada.is_connected(_actualizar_progreso):
		contador.limpieza_actualizada.disconnect(_actualizar_progreso)

	APuerta.play("puerta_abierta")


func preguntar_puerta():
	SignalBus.preguntar_pasar_por_valla.emit(entrada_posicion)


func pasar_puerta(entrada: int):
	if entrada != entrada_posicion: return
	SignalBus.hacer_transicion.emit()
	SignalBus.entrada_de_checkpoint.emit(entrada_posicion)
	await get_tree().create_timer(1).timeout

	if SignalBus.interaccion.is_connected(_al_interactuar):
		SignalBus.interaccion.disconnect(_al_interactuar)

	$CollisionShape2D.disabled = true
	SaveGame.Cambiar_Escena(next_scene)
