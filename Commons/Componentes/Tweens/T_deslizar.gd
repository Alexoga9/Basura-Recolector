class_name TDeslizar extends Node

var padre: Node2D


func _ready():
	padre = get_parent()
	tween()


func tween():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(padre, "position", (padre.global_position + Vector2(randi_range(-20,20), 50)), 1)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_EXPO)
