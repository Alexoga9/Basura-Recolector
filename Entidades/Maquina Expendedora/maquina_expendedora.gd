extends StaticBody2D

@export var precio: int = 50
@export var consumible: PackedScene
var jugador
@onready var audio = %audio
@onready var animacion: AnimatedSprite2D = %AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.interaccion.connect(dispensar)


func _on_trigger_jugador_body_entered(body):
	jugador = body


func _on_trigger_jugador_body_exited(body):
	jugador = null


func dispensar():
	if jugador != null and animacion.animation == "Idle":
		if Dinero.dinero >= precio:
			animacion.play("Dispensar")
			Dinero.gastar(precio)


func spawnear():
	var nuevo: Consumible = consumible.instantiate()

	nuevo.global_position = self.global_position #+ Vector2(0, 50)
	get_tree().current_scene.add_child(nuevo)


func _on_animated_sprite_2d_frame_changed():
	if animacion == null:
		return # Seguridad para evitar el error

	if animacion.animation != "Dispensar":
		return

	if animacion.animation == "Dispensar" and animacion.frame == 3:
		spawnear()
		audio.play()


func _on_audio_finished():
	animacion.play("Idle")
