class_name TiendaUI extends Control

@onready var caja_de_compras = %"Caja de compras"
@export var panelTienda: Array[PanelTienda]
@onready var tienda_ui: TiendaUI = $"."


func _ready() -> void:
	SignalBus.mostrar_tienda.connect(mostrar_tienda)
	SignalBus.ocultar_tienda.connect(ocultar_tienda)

	visibility_changed.connect(_on_visibility_changed)


func mostrar_tienda() -> void:
	Interfaces.abrir_interfaz(tienda_ui)


func ocultar_tienda() -> void:
	Interfaces.cerrar_interfaz_especifica(tienda_ui)


func _on_visibility_changed() -> void:
	if visible:
		Global.jugador.set_mument_enable(false)
	else:
		Global.jugador.set_mument_enable(true)


# func set_focus_tienedabotones():
#	for focu in panelTienda:
#		focu.boton.grab_focus()
