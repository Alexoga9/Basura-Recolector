extends StaticBody2D

@export var precio: int = 50
@export var consumible: PackedScene
var jugador

@onready var audio: AudioStreamPlayer = %audio
@onready var animacion: AnimatedSprite2D = %AnimatedSprite2D

var dispensando: bool = false
# Variable para saber si ya se dispensó el objeto en esta interacción
var ya_dispensado: bool = false


func _ready():
	animacion.frame_changed.connect(_on_animated_sprite_2d_frame_changed)


func _process(delta):
	if Input.is_action_just_pressed("Interaccion") and jugador != null and not dispensando:
		comenzar_dispensar()


func comenzar_dispensar():
	if dispensando:
		return

	if Dinero.dinero >= precio:
		# 🟢 RESERVAMOS el dinero en el momento del clic (solo 1 vez)
		Dinero.gastar(precio)

		# Activamos el estado de dispensado
		dispensando = true
		ya_dispensado = false # Reiniciamos el control de dispensado

		# Reproducimos la animación y el audio
		animacion.animation = "Dispensar"
		audio.play()
	else:
		print("No tienes suficiente dinero")


func _on_animated_sprite_2d_frame_changed():
	# Si no estamos dispensando, salimos
	if not dispensando:
		return

	# 🟢 SOLO DISPENSAMOS SI NO LO HEMOS HECHO YA EN ESTA INTERACCIÓN
	if animacion.frame == 3 and not ya_dispensado:
		ya_dispensado = true # Marcamos que ya salió el objeto
		spawnear()


func spawnear():
	var nuevo: Consumible = consumible.instantiate()
	nuevo.global_position = self.global_position
	get_tree().current_scene.add_child(nuevo)


func _on_audio_finished():
	animacion.animation = "Idle"
	dispensando = false
	ya_dispensado = false # Reiniciamos por seguridad


func _on_trigger_jugador_body_entered(body):
	jugador = body


func _on_trigger_jugador_body_exited(body):
	jugador = null
