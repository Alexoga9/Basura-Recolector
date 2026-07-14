extends Control

@onready var menu: Control = %Menu
@onready var opciones: Control = %Opciones


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.mostrar_menu_principal.connect(mostrar_menu_principal)


func _on_jugar_pressed():
	hide()
	SignalBus.mostrar_hud.emit()
	#añadir tweens


func _on_opciones_pressed():
	menu.hide()
	opciones.show()


func mostrar_menu_principal():
	menu.show()
	print("se muestra el menu principal")
