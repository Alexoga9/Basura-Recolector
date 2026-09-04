extends BarraDeProgreso

@onready var barra_secundaria_basura: BarraDeProgreso = %"Barra secundaria basura"
@onready var timer: Timer = %"Timer basura"


#func _ready():
	#Inventario.slot_updated.connect(_on_value_changed)


# argumento: nombre
func _on_value_changed(value):
	#print("timer iniciado")
	timer.start()


func _on_timer_timeout():
	#timer_lineal.start()
	barra_secundaria_basura.value = valor_actual


func _on_changed():
	barra_secundaria_basura.max_value = valor_max


func datos_barra_secundaria():
	#await get_tree().create_timer(2.0).timeout
	barra_secundaria_basura.valor_actual = lerp(barra_secundaria_basura.valor_actual, valor_actual, 0.5)
	barra_secundaria_basura.valor_max = lerp(barra_secundaria_basura.valor_max, valor_max, 0.5)
