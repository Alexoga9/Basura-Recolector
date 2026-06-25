@icon("res://addons/iconos/Game Over.svg")
class_name Agotamiento extends Node

signal estamina_agotada

@export var vida: EnergiaComponente

# cambiar esto por agotamiento


func _on_vida_componente_murio():
	estamina_agotada.emit()
	print_rich("[color=GOLD][shake rate=20.0 level=5 connected=1]{Agotado}[/shake]")
