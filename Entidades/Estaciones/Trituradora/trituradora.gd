extends StaticBody2D

@onready var audio = %audio
@onready var sierras = %Sierras
@onready var chispas = %Chispas

var interaccion_del_jugador: bool = false
var jugador_en_area: bool = false


func _ready():
	SignalBus.interaccion.connect(interaccion_recibida)


func _process(delta):
	depositar_basura()


func interaccion_recibida():
	if not jugador_en_area:
		return

	interaccion_del_jugador = !interaccion_del_jugador


func depositar_basura():
	if interaccion_del_jugador and jugador_en_area:
		recibir_basura_jugador()


func recibir_basura_jugador():
	if Inventario.peso > 0:
		Dinero.ganar(Inventario.valor_de_basuras)
		Inventario.peso = 0
		Inventario.valor_de_basuras = 0
		audio.play()
		sierras.play()
		chispas.play()


func recibir_basura_fisica(body):
	Dinero.ganar(body.valor)
	body.collect()
	audio.play()
	sierras.play()
	chispas.play()


func _on_trigger_basura_body_entered(body):

	if body.is_in_group("Jugador"):
		jugador_en_area = true

	if body.is_in_group("BolsaDeBasura"):
		recibir_basura_fisica(body)


func _on_chispas_animation_finished():
	chispas.frame = 0


func _on_trigger_jugador_body_exited(body):
	if body.is_in_group("Jugador"):
		jugador_en_area = false
		interaccion_del_jugador = false
