extends Control

@export var panel_opciones: Control
@onready var master_slider = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/MasterSlider


func _on_atras_pressed():
	hide()
	panel_opciones.show()
