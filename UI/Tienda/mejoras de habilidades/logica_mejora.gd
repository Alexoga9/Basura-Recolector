@icon("res://addons/iconos/mejora.svg")
class_name Logica_Mejora extends Node
## Acompañado de un PanelTienda, funciona para ejecutar codigo
## con la intención de mejorar habilidades u objetos del jugador

var jugador: Jugador
var panel: PanelTienda


func iniciar():
	await get_tree().process_frame
	jugador = Global.jugador
	panel = get_parent()
	actualizar_datos()


func aplicar_mejora():
	actualizar_datos()
	pass


func actualizar_datos():
	pass
