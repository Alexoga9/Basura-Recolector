class_name Jugador extends CharacterBody2D

# Funcionalidad
@onready var input_componente: InputComponente = %InputComponente
@onready var movimiento_componente: MovimientoComponente = %MovimientoComponente
@onready var recoge_basura: RadarComponenteBasura = %"Recoge BASURA"
@onready var lanza_basura: LanzaBasura = %"Lanza Basura"

# In Game
@onready var energia_componente: EnergiaComponente = %EnergiaComponente
@onready var camera_2d: Camera2D = %Camera2D


func _ready():
	Global.set_jugador(self)
	SignalBus.jugador_listo.emit()


func _physics_process(delta):
	movimiento_componente.movimiento(input_componente.input_movimiento(), delta)
	input_componente.input_recoger_basura_automatica()
	#marker_2d.actualizar_marker_por_input(input_componente.input_movimiento())
