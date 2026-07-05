extends Control

@onready var barra_energia = %BarraEnergia
@onready var barra_basura = %BarraBasura

@onready var barra_cooldown = %BarraCooldown

var jugador: Jugador


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	jugador = Global.jugador


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	igualar_barra_energia()


func igualar_barra_energia():
	barra_energia.valor_max = jugador.energia_componente.energia_maxima
	barra_energia.valor_actual = jugador.energia_componente.energia

	barra_cooldown.valor_max = jugador.recoge_basura.timer.wait_time
	barra_cooldown.valor_actual = jugador.recoge_basura.timer.time_left
