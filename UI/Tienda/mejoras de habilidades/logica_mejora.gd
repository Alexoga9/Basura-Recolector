class_name Logica_Mejora extends Node

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
