extends Control

@export var hud: Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_continuar_pressed():
	get_tree().paused = false
	hide()


func _on_menu_principal_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
