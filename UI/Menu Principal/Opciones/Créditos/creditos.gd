extends Control

@export var panel_opciones: Control


func _on_atras_pressed():
	AudiosGlobales.boton.play()
	hide()
	panel_opciones.show()
