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

func triangulo_compuesto():
	var lado: float = 10
	var base_triangulo: float = 30
	var radio: float = base_triangulo/2
	
	var punto_A = Vector2(radio, lado)
	var punto_B = Vector2(-radio, lado)
	var punto_C = Vector2(0, 0)
	
	var semicirculo = (PI*pow((radio), 2)) / 2
