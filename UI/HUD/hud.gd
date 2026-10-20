extends Control

@export var panel_pausa: Pausa
@onready var hud_juego = %HudJuego
@export var panel: bool


func _ready() -> void:
	SignalBus.input_esc.connect(_on_pausa_pressed)
	SignalBus.mostrar_hud.connect(mostrar)

	# Detectar cuando el menú se abre o se cierra.
	panel_pausa.visibility_changed.connect(_on_pausa_visibility_changed)

	# Permitir que el menú funcione mientras el juego está pausado.
	panel_pausa.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_pausa_pressed() -> void:
	if panel_pausa.visible:
		_on_pausa_exit()
	else:
		Interfaces.abrir_interfaz(panel_pausa)


func _on_pausa_exit() -> void:
	Interfaces.cerrar_interfaz_especifica(panel_pausa)


func _on_pausa_visibility_changed() -> void:
	if panel_pausa.visible:
		get_tree().paused = true
		panel_pausa.continuar.grab_focus()
	else:
		get_tree().paused = false


func mostrar() -> void:
	hud_juego.show()
