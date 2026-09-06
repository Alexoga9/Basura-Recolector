class_name LabelSombreado extends Label

var hijo: Label
@onready var label: Label = %Label


func _ready():
	label.text = text
	float(2)


func actualizar_labels(texto):
	var txt: String = str(texto)
	text = txt
	label.text = txt
