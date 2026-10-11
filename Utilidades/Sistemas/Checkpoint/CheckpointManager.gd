extends Node

## Checkpoint por el que debe aparecer el jugador en la escena actual.
## 0 = ninguno pendiente.
var saldra_por: int = 0

## Registro de checkpoints de la escena actual: {entrada: CheckpointComponente}
var registro: Dictionary = {}


func _ready():
	# Al iniciar el juego, si venimos de una valla, ya tenemos el valor.
	# Si no, se queda en 0 y no mueve a nadie.
	# Escuchar la señal por si la valla está en la escena actual.
	SignalBus.entrada_de_checkpoint.connect(decidir_entrada)

# ------------------------------------------------------------------
# API para los CheckpointComponente
# ------------------------------------------------------------------


func registrar(entrada: int, checkpoint: CheckpointComponente) -> void:
	registro[entrada] = checkpoint

	# Si este checkpoint es el destino pendiente, intentar mover al jugador.
	if entrada == saldra_por:
		call_deferred("_intentar_mover_jugador", entrada)


func desregistrar(entrada: int) -> void:
	registro.erase(entrada)

# ------------------------------------------------------------------
# Lógica de decisión (valla → manager)
# ------------------------------------------------------------------


## La valla emite SignalBus.entrada_de_checkpoint con el número
## de la dirección por la que el jugador SALE. El manager calcula
## la dirección opuesta (por la que debe ENTRAR en la nueva escena).
func decidir_entrada(entro_por: int) -> void:
	match entro_por:
		0:
			saldra_por = 0

		1:
			saldra_por = 4

		2:
			saldra_por = 3

		3:
			saldra_por = 2

		4:
			saldra_por = 1

# ------------------------------------------------------------------
# Mover al jugador cuando todo esté listo
# ------------------------------------------------------------------


func _intentar_mover_jugador(entrada: int) -> void:
	# Verificar que seguimos queriendo este checkpoint
	if entrada != saldra_por:
		return

	var checkpoint := registro.get(entrada) as CheckpointComponente

	if checkpoint == null:
		return

	# Esperar a que el jugador exista y sea válido
	var intentos := 0

	while not _jugador_valido() and intentos < 120:
		await get_tree().process_frame
		intentos += 1

	if not _jugador_valido():
		push_warning("CheckpointManager: no se encontró un jugador válido")
		return

	Global.jugador.global_position = checkpoint.global_position

	# Consumir el pendiente para no repetir
	saldra_por = 0


func _jugador_valido() -> bool:
	return Global.jugador != null and is_instance_valid(Global.jugador)
