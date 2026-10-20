extends BarraDeProgreso

@onready var recoge_basura: RadarComponente = %RadarComponente


func _process(delta):
	if recoge_basura.cooldown_activo:
		visible = true

		# Usamos directamente las propiedades nativas de ProgressBar
		# para evitar el lerp del padre.
		max_value = recoge_basura.cooldown_tiempo
		value = recoge_basura.timer.time_left
	else:
		visible = false
