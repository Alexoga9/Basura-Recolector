class_name TRecogida extends Node

var padre: Node2D


func _ready():
	padre = get_parent()


func tween():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(padre, "scale", Vector2(0, 0), 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
