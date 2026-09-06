class_name TiendaUi extends Control

@onready var caja_de_compras = %"Caja de compras"

func _ready():
	SignalBus.mostrar_tienda.connect(mostrar_tienda)
	SignalBus.ocultar_tienda.connect(ocultar_tienda)


func _process(delta):
	pass


func mostrar_tienda():
	show()


func ocultar_tienda():
	hide()
