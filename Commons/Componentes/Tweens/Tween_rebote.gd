class_name TweenRebote extends Node

var padre: Node2D


func _ready():
	padre = get_parent()


func tween():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(padre, "scale", Vector2(1.1, 1.1), 0.1)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(padre, "scale", Vector2(1, 1), 0.1)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_ELASTIC)
