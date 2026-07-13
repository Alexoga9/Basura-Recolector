extends Control

@export var panel_pausa: Control
@onready var hud_juego = %HudJuego


func _ready():
	inicializar()


func inicializar():
	SignalBus.mostrar_hud.connect(mostrar)


func _on_pausa_pressed():
	panel_pausa.show()
	get_tree().paused = true


func mostrar():
	hud_juego.show()
