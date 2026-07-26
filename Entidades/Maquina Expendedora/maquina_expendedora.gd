extends StaticBody2D

@export var precio: int = 50
@export var consumible: PackedScene
var jugador
@onready var audio: AudioStreamPlayer = %audio
@onready var animacion: AnimatedSprite2D = %AnimatedSprite2D


#func _process(delta):
	#dispensar()


func _on_trigger_jugador_body_entered(body):
	jugador = body


func _on_trigger_jugador_body_exited(body):
	jugador = null


func dispensar():
	if Input.is_action_just_pressed("Interaccion") and jugador != null:
		if Dinero.dinero >= precio:
			spawnear()
			audio.play()
			Dinero.gastar(precio)

			#print("Te costo el honguito we, te queda "+ str(Dinero.dinero))


func spawnear():
	var nuevo: Consumible = consumible.instantiate()

	nuevo.global_position = self.global_position #+ Vector2(0, 50)
	get_tree().current_scene.add_child(nuevo)


func _on_animated_sprite_2d_frame_changed():
	if animacion.animation == "Dispensar":
		if animacion.frame == 3: 
			dispensar()
