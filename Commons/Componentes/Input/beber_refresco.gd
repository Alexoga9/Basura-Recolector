class_name BeberRefresco extends Node

@onready var energia_componente: EnergiaComponente = %EnergiaComponente
@onready var audio_refresco:AudioStreamPlayer = %AudioRefresco


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.beber_refresco.connect(beber_refresco)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func beber_refresco():
	if Inventario.get_count("refresco") > 0:
		audio_refresco.play()
		Inventario.remove_item("refresco")
		energia_componente.energia += 2 + (NivelesDeExperiencia.nivel_refrescos * 1)


func _on_audio_stream_player_finished():
	pass # Replace with function body.
