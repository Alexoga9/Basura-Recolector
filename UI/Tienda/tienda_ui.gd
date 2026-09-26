class_name TiendaUI extends Control

@onready var caja_de_compras = %"Caja de compras"
@export var panelTienda: Array[PanelTienda]


func _ready():
	SignalBus.mostrar_tienda.connect(mostrar_tienda)
	SignalBus.ocultar_tienda.connect(ocultar_tienda)


func _process(delta):
	pass


func mostrar_tienda():
	Global.jugador.set_mument_enable(false)
	show()


func ocultar_tienda():
	Global.jugador.set_mument_enable(true)
	hide()


# func set_focus_tienedabotones():
#	for focu in panelTienda:
#		focu.boton.grab_focus()
