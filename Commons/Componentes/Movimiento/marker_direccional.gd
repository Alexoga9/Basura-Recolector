class_name MarkerDireccional extends Marker2D


func actualizar_marker_por_input(direccion: Vector2):
	# Actualizar la rotación del marker basada en la dirección del input
	if direccion != Vector2.ZERO:
		# Convertir la dirección a ángulo y rotar el marker
		rotation = direccion.angle()
