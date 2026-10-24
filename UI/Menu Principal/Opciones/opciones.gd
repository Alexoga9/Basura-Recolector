extends Control

@export var panel_opciones: Control
@export var panel_audio: Control
@export var panel_salir: Control
@export var panel_creditos: Control


func _on_atras_pressed():
	AudiosGlobales.boton.play()
	hide()
	SignalBus.mostrar_menu_principal.emit()


func _on_audio_pressed():
	AudiosGlobales.boton.play()
	panel_opciones.hide()
	panel_audio.show()


func _on_salir_pressed():
	AudiosGlobales.boton.play()
	panel_opciones.hide()
	panel_salir.show()


func _on_creditos_pressed():
	AudiosGlobales.boton.play()
	panel_opciones.hide()
	panel_creditos.show()
