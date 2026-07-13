extends Control

@export var panel_opciones: Control


func _on_salir_2_pressed():
	get_tree().quit()


func _on_quedarse_pressed():
	hide()
	panel_opciones.show()
