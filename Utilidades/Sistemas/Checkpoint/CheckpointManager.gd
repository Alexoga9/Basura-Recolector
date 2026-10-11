class_name CheckpointManager extends Node

var saldra_por: int = Global.entrada_puerta


# Called when the node enters the scene tree for the first time.
func _ready():
	#SignalBus.entrada_de_checkpoint.connect(decidir_entrada)
	decidir_entrada(saldra_por)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func decidir_entrada(entro_por: int):
	match entro_por:
		0:
			pass

		1:
			saldra_por = 4

		2:
			saldra_por = 3

		3:
			saldra_por = 2

		4:
			saldra_por = 1
