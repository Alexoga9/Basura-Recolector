class_name Jugador extends CharacterBody2D

# Funcionalidad
@onready var input_componente: InputComponente = %InputComponente
@onready var movimiento_componente: MovimientoComponente = %MovimientoComponente
@onready var recoge_basura: RadarComponenteBasura = %"Recoge BASURA"
@onready var recoge_obstaculos: RadarComponenteObstaculos = %"Recoge OBSTACULOS"

@onready var lanza_basura: LanzaBasura = %"Lanza Basura"
@onready var estadisticas_componente: EstadisticasComponente = %EstadisticasComponente

# In Game
@onready var energia_componente: EnergiaComponente = %EnergiaComponente


func _ready():
	Global.set_jugador(self)
	SignalBus.jugador_listo.emit()


func _physics_process(delta):
	movimiento_componente.movimiento(input_componente.input_movimiento(), delta)
