class_name Pausa extends Control

@onready var continuar: Button = $MarginContainer/PanelContainer/VBoxContainer/Continuar
@export var hud: Control
@onready var opciones = %Opciones


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_continuar_pressed():
	get_tree().paused = false
	Interfaces.cerrar_interfaz_especifica(self)
	AudiosGlobales.boton.play()


func _on_menu_principal_pressed():
	Interfaces.cerrar_interfaz_especifica(self)
	get_tree().paused = false
	SaveGame.Cambiar_Escena("uid://kyb4e7wfvufr")
	AudiosGlobales.boton.play()


func saveGame():
	SaveGame.Guardar()
	get_tree().paused = false
	Interfaces.cerrar_interfaz_especifica(self)


func load_game() -> void:
	SaveGame.Cargar()
	get_tree().paused = false
	Interfaces.cerrar_interfaz_especifica(self)


func reset() -> void:
	get_tree().paused = false
	SaveGame.Reset_Game()
	Interfaces.cerrar_interfaz_especifica(self)


func _on_opciones_pressed():
	opciones.show()
	AudiosGlobales.boton.play()
