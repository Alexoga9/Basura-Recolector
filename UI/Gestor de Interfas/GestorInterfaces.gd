extends Node

var interfaz_actual: Control = null


func abrir_interfaz(interfaz: Control) -> void:
	if not is_instance_valid(interfaz):
		return

	# Si ya está abierta, no hacer nada.
	if interfaz_actual == interfaz:
		interfaz.show()
		return

	# Cerrar la interfaz anterior.
	cerrar_interfaz()

	# Abrir la nueva interfaz.
	interfaz_actual = interfaz
	interfaz_actual.show()


func cerrar_interfaz() -> void:
	var anterior := interfaz_actual
	interfaz_actual = null
	if is_instance_valid(anterior):
		anterior.hide()


func cerrar_interfaz_especifica(interfaz: Control) -> void:
	if interfaz_actual == interfaz:
		cerrar_interfaz()
