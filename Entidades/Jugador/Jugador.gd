class_name Jugador extends CharacterBody2D

# Funcionalidad
@onready var input_componente: InputComponente = %InputComponente
@onready var movimiento_componente: MovimientoComponente = %MovimientoComponente
@onready var radar_componente: RadarComponente = %RadarComponente
@onready var beber_refresco: BeberRefresco = %BebeRefresco

@onready var contador_componente: ContadorComponente = %ContadorComponente

@onready var lanza_basura: LanzaBasura = %"Lanza Basura"
@onready var estadisticas_componente: EstadisticasComponente = %EstadisticasComponente
var canMove = true
const TEXTO_RECOGIDA = preload("res://UI/Theme/shaders/label_personalizado.tscn")


func mostrar_recogida(nombre_objeto: String) -> void:
	var mensaje: LabelSombreado = TEXTO_RECOGIDA.instantiate()
	mensaje.text = "Recogiste: " + nombre_objeto.replace("_", " ")
	mensaje.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mensaje.z_index = 100
	add_child(mensaje)
	mensaje.get_node("Label").mouse_filter = Control.MOUSE_FILTER_IGNORE
	mensaje.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	mensaje.reset_size()
	mensaje.position = Vector2(-mensaje.size.x / 2.0, -40.0)
	var animacion := create_tween()
	animacion.tween_property(mensaje, "position:y", -60.0, 1.5)
	animacion.parallel().tween_property(mensaje, "modulate:a", 0.0, 0.5).set_delay(1.0)
	animacion.tween_callback(mensaje.queue_free)

# In Game
@onready var energia_componente: EnergiaComponente = %EnergiaComponente


func _ready():
	Global.set_jugador(self)
	SignalBus.jugador_listo.emit()


func set_mument_enable(value):
	canMove = value


func _physics_process(delta):
	if canMove and not Interfaces.juego_bloqueado():
		movimiento_componente.movimiento(input_componente.input_movimiento(), delta)
	else:
		velocity = Vector2.ZERO


func _exit_tree():
	if Global.jugador == self:
		Global.jugador = null
