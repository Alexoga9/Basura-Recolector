extends BarraDeProgreso

@onready var barra_secundaria_energia = %"Barra secundaria energia"
@onready var timer = %Timer
@onready var timer_lineal = %"Timer lineal"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_value_changed(value):
	print("timer iniciado")
	timer.start()


func _on_timer_timeout():
	#timer_lineal.start()
	barra_secundaria_energia.value = value

	print(str(barra_secundaria_energia.value) + " " + str(valor_actual))


func _on_changed():
	barra_secundaria_energia.max_value = valor_max


func datos_barra_secundaria():
	barra_secundaria_energia.value = valor_actual
	barra_secundaria_energia.max_value = valor_max


func _on_timer_lineal_timeout():
	pass # Replace with function body.
