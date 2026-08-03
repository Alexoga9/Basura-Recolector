extends BarraDeProgreso

@onready var recoge_basura: RadarComponenteBasura = %"Recoge BASURA"


func _process(delta):
	if recoge_basura.cooldown_activo:
		visible = true
		valor_max = recoge_basura.timer.wait_time
		valor_actual = recoge_basura.timer.time_left
	else:
		visible = false
