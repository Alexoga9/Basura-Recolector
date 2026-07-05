extends StaticBody2D

@export var consumible: PackedScene
var jugador
@onready var audio = %audio


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dispensar()


func _on_trigger_jugador_body_entered(body):
	jugador = body


func _on_trigger_jugador_body_exited(body):
	jugador = null


func dispensar():
	if Input.is_action_just_pressed("Interaccion") and jugador != null:
		spawnear()
		audio.play()

		print("Toma we")


func spawnear():
	var nuevo = consumible.instantiate()
	nuevo.global_position = self.global_position + Vector2(0, 50)
	get_tree().current_scene.add_child(nuevo)
