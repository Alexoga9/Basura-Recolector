extends BarraDeProgreso

@onready var barra_secundaria_energia: ProgressBar = %"Barra secundaria energia"
@onready var timer: Timer = %"Timer energia"


func _ready():
	actualizar_barra()
	#datos_barra_secundaria()


#func _on_value_changed(value):
	##print("timer iniciado")
#
	#if barra_secundaria_energia.value > valor_actual:
		#timer.stop()
		#timer.start()


func _on_timer_timeout():
	datos_barra_secundaria()


#func _on_changed():
	#barra_secundaria_energia.max_value = valor_max


func datos_barra_secundaria():
	#await get_tree().create_timer(2.0).timeout
	barra_secundaria_energia.value = lerp(barra_secundaria_energia.value, valor_actual, 0.01)
	barra_secundaria_energia.max_value = lerp(barra_secundaria_energia.max_value, valor_max, 0.01)
