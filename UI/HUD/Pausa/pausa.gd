extends Control

@export var hud: Control


func _on_continuar_pressed():
	get_tree().paused = false
	hide()


func _on_menu_principal_pressed():
	get_tree().paused = false

	get_tree().reload_current_scene()
