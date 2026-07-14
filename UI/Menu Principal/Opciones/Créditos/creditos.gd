extends Control

@export var panel_opciones: Control


func _on_atras_pressed():
	hide()
	panel_opciones.show()
