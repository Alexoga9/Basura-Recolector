extends Control

@onready var titulo: Label = %Titulo
@onready var texto: Label = %Texto


func _ready():
	SignalBus.notas_menu.connect(al_recoger_nota)
	SignalBus.input_click.connect(ocultar_nota)


func al_recoger_nota(data: DataNotas):
	mostrar_nota()
	asignar_datos(data)


func mostrar_nota():
	show()


func ocultar_nota():
	hide()


func asignar_datos(data: DataNotas):
	titulo.text = data.titulo_nota
	texto.text = data.texto_nota
