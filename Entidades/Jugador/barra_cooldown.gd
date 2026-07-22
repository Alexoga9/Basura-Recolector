extends BarraDeProgreso

@onready var recoge_basura: RadarComponenteBasura = %"Recoge BASURA"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if recoge_basura.cooldown_activo:
		visible = true
		valor_max = recoge_basura.timer.wait_time
		valor_actual = recoge_basura.timer.time_left
	else:
		visible = false
