@icon("res://addons/iconos/Game Over.svg")
class_name GameOver extends Node

signal game_over

@export var vida: VidaComponente


func _on_vida_componente_murio():
	game_over.emit()
	get_owner().visible = false
