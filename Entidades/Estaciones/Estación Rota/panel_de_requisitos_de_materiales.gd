extends Panel

@export var estacion_rota: EstacionRota
@onready var contenedor: HBoxContainer = %Contenedor
@export var casilla: PackedScene


func _ready():
	SignalBus.actualizar_estacion_rota.connect(actualizar_valores)
	contenedores()


## Crea una cantidad de contenedores igual al array de EstacionRota
func contenedores():
	for i in estacion_rota.materiales.size():
		var nuevo_casilla = casilla.instantiate()
		contenedor.add_child(nuevo_casilla)
		establecer_valores(nuevo_casilla, i)


## Esconde el contenedor completado
func actualizar_valores():
	print("actualizando...")
	contenedor.get_child_count()
	for i in estacion_rota.materiales.size():
		var hijo = contenedor.get_child(i)
		establecer_valores(hijo, i)
		if hijo.label.text == "0":
			hijo.hide()


## Asigna valores de cantidad y sprite
func establecer_valores(casilla: CasillaDeRequisitoMateriales, i):
	casilla.label.text = str(estacion_rota.materiales[i].cantidad_necesaria)
	casilla.texture_rect.texture = estacion_rota.materiales[i].imagen
