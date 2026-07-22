extends StaticBody2D

@export var precio: int = 50
@export var consumible: PackedScene
var jugador
@onready var audio = %audio
@onready var sprite = %Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dispensar()


func _on_trigger_jugador_body_entered(body):
	jugador = body
	sprite.frame = 1


func _on_trigger_jugador_body_exited(body):
	jugador = null
	sprite.frame = 0


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
