@icon("res://addons/iconos/tween.svg")
class_name TDeslizar extends Node

var padre: Node2D
var rango: float = 20
var distancia: float = 50


func _ready():
	padre = get_parent()
	tween()


func tween():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(padre, "position", (padre.global_position + Vector2(randf_range(-rango,rango), distancia)), 1)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_EXPO)
