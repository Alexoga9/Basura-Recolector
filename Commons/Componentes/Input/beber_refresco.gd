class_name BeberRefresco extends Node

@export var energia_componente: EnergiaComponente
@onready var audio_refresco:AudioStreamPlayer = %AudioRefresco

var energia_recuperada: int = 2


func _ready():
	SignalBus.beber_refresco.connect(beber_refresco)


func beber_refresco():
	if Inventario.get_count("refresco") > 0:
		audio_refresco.play()
		Inventario.remove_item("refresco")
		energia_componente.energia += energia_recuperada
