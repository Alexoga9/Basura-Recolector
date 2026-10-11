class_name CheckpointComponente extends Node2D

@export var entrada: int = 0


func _ready():
	if entrada == 0:
		push_warning("Checkpoint sin entrada asignada: ", get_path())
		return

	CheckpointManager.registrar(entrada, self)


func _exit_tree():
	CheckpointManager.desregistrar(entrada)
