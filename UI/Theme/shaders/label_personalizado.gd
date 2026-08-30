class_name LabelSombreado extends Label

var hijo: Label


func _ready():
	hijo = get_child(0)


func actualizar_labels(texto:String):
	text = texto
	hijo.text = texto
