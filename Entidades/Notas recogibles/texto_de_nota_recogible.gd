extends Control

@export var data: DataNotas

@onready var titulo: Label = %Titulo
@onready var texto: Label = %Texto


func _ready():
	asignar_datos()


func asignar_datos():
	titulo.text = data.titulo_nota
	texto.text = data.texto_nota
