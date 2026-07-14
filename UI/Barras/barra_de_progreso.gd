@tool
class_name BarraDeProgreso extends ProgressBar

@export var valor_max: float:
	set(valor):
		valor_max = valor
		actualizar_barra()

@export var valor_actual: float:
	set(valor):
		valor_actual = valor
		actualizar_barra()

var valor_faltante: float


func _ready():
	actualizar_barra()
	datos_barra_secundaria()


func valor_cambiado(nuevo_valor: float):
	# Este método recibe la señal del componente de vida
	valor_actual = nuevo_valor


func valor_maximo_cambiado(nuevo_max: float):
	valor_max = nuevo_max


func actualizar_barra():
	if valor_max > 0:
		# Calcular el porcentaje directamente
		value = (valor_actual / valor_max) * 100

		# Opcional: también puedes calcular valor_faltante
		valor_faltante = valor_max - valor_actual

		# Debug
		#print("Barra actualizada - Actual: ", valor_actual, " Max: ", valor_max, " %: ", value)


func datos_barra_secundaria():
	pass
