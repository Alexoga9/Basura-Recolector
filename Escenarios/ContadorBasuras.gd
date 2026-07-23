extends ProgressBar

var cantidad_de_basuras: int
var basuras_actuales: int
var porcentaje: int = 0
@onready var cleared: Label = %Cleared


func _ready():
	cantidad_de_basuras = get_tree().get_node_count_in_group("Basura")
	max_value = cantidad_de_basuras

	# 2. Si no hay basura, evitamos errores
	if cantidad_de_basuras <= 0:
		max_value = 1 # Para evitar división entre cero
		cleared.text = "Cleared 0%"
		return

	# 3. Conectamos la señal al final (para evitar conflictos de carga)
	SignalBus.basura_recogida.connect(añadir_basura)

	# 4. Esperamos UN FRAME a que el nodo esté completamente en la escena
	await get_tree().process_frame

	# 5. Ahora sí, contamos y mostramos el porcentaje inicial (0%)
	contar_basura()


func contar_basura():
	if max_value <= 0:
		return

	value = basuras_actuales
	# Calculamos el porcentaje usando 'ratio' (0.0 a 1.0)
	porcentaje = int(ratio * 100)
	cleared.text = "Cleared " + str(porcentaje) + "%"
	print("Porcentaje actual: ", porcentaje)


func añadir_basura():
	basuras_actuales += 1
	contar_basura()
