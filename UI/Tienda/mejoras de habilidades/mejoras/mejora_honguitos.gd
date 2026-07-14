extends Logica_Mejora

@export var honguito: DataConsumible


func _ready():
	iniciar()


func aplicar_mejora():
	honguito.recuperar_energia += 2
