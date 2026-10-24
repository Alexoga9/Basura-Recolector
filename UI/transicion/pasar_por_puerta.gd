extends Control

var entrada_de_valla: int


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.preguntar_pasar_por_valla.connect(mostrar)


func mostrar(entrada: int):
	AudiosGlobales.abrir_menu.play()
	entrada_de_valla = entrada
	show()


func _on_entrar_pressed():
	AudiosGlobales.boton.play()
	hide()
	SignalBus.pasar_entrada_valla.emit(entrada_de_valla)


func _on_quedarse_pressed():
	AudiosGlobales.boton.play()
	hide()
