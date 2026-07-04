extends Control


func _ready():
	SignalBus.mostrar_tienda.connect(mostrar_tienda)
	SignalBus.ocultar_tienda.connect(ocultar_tienda)


func _process(delta):
	pass


func mostrar_tienda():
	show()


func ocultar_tienda():
	hide()
