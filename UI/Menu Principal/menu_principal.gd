extends Control

@onready var menu: Control = %Menu
@onready var opciones: Control = %Opciones


func _ready():
	SignalBus.mostrar_menu_principal.connect(mostrar_menu_principal)
	SignalBus.terminar_transicion.connect(empezar_a_jugar)


func _on_jugar_pressed():
	SignalBus.hacer_transicion.emit()
	#menu.hide()
	#SignalBus.mostrar_hud.emit()
	#añadir tweens


func empezar_a_jugar():
	SaveGame.Cambiar_Escena("uid://cbesogarip1ji")


func _on_opciones_pressed():
	menu.hide()
	opciones.show()


func mostrar_menu_principal():
	menu.show()
	#print("se muestra el menu principal")
