extends BarraDeProgreso

@onready var barra_secundaria_energia: BarraDeProgreso = %"Barra secundaria energia"
@onready var timer: Timer = %"Timer energia"


func _ready():
	actualizar_barra()
	#datos_barra_secundaria()


func _on_value_changed(value):
	#print("timer iniciado")

	if barra_secundaria_energia.value > valor_actual:
		timer.stop()
		timer.start()


func _on_timer_timeout():
	datos_barra_secundaria()


#func _on_changed():
	#barra_secundaria_energia.max_value = valor_max


func datos_barra_secundaria():
	#await get_tree().create_timer(2.0).timeout
	barra_secundaria_energia.valor_actual = lerp(barra_secundaria_energia.valor_actual, valor_actual, 0.5)
	barra_secundaria_energia.valor_max = lerp(barra_secundaria_energia.valor_max, valor_max, 0.5)
