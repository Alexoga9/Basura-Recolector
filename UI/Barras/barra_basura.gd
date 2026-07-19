extends BarraDeProgreso

@onready var barra_secundaria_energia: ProgressBar = %"Barra secundaria energia"
@onready var timer: Timer = %"Timer basura"


func _ready():
	Inventario.slot_updated.connect(_on_value_changed)


func _on_value_changed(nombre, value):
	print("timer iniciado")
	timer.start()


func _on_timer_timeout():
	#timer_lineal.start()
	barra_secundaria_energia.value = valor_actual


func _on_changed():
	barra_secundaria_energia.max_value = valor_max


func datos_barra_secundaria():
	barra_secundaria_energia.value = valor_actual
	barra_secundaria_energia.max_value = valor_max
