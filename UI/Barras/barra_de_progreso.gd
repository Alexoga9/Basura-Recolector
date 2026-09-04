class_name BarraDeProgreso extends ProgressBar

@export var valor_max: float:
	set(valor):
		valor_max = lerp(valor_max, valor, 0.09)
		actualizar_barra()

@export var valor_actual: float:
	set(valor):
		valor_actual = lerp(valor_actual, valor, 0.09)
		actualizar_barra()

var valor_faltante: float


func _ready():
	actualizar_barra()
	datos_barra_secundaria()


## Este método recibe la señal del componente de vida
func valor_cambiado(nuevo_valor: float):
	valor_actual = nuevo_valor


func valor_maximo_cambiado(nuevo_max: float):
	valor_max = nuevo_max


func actualizar_barra():
	if valor_max > 0:
		# Calcula el porcentaje directamente
		value = (valor_actual / valor_max) * 100
		#await value
		#datos_barra_secundaria()

		valor_faltante = valor_max - valor_actual

		# Debug
		#print("Barra actualizada - Actual: ", valor_actual, " Max: ", valor_max, " %: ", value)


func datos_barra_secundaria():
	pass
