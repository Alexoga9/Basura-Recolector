class_name ContadorUI extends ProgressBar

var porcentaje: int = 0
@onready var cleared: Label = %Cleared


func _ready():
	Global.jugador.contador_componente.limpieza_actualizada.connect(actualizar_ui)


func actualizar_ui(porcentaje: int):
	value = porcentaje
	cleared.text = "Cleared " + str(porcentaje) + "%"
