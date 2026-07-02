extends Control

@export var precio_resistencia: int
@export var precio_velocidadRecogida: int
@export var precio_lanzamiento: int
@export var precio_poderGolpe: int
@export var precio_recuperacion: int
@export var precio_rango: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func verificar_precio(precio:int):
	if Dinero.dinero >= precio:
		pass


func _on_resistencia_de_energía_pressed():
	verificar_precio(precio_resistencia)


func _on_velocidad_de_recolección_pressed():
	verificar_precio(precio_velocidadRecogida)


func _on_poder_de_lanzamiento_pressed():
	verificar_precio(precio_lanzamiento)


func _on_poder_de_golpe_pressed():
	verificar_precio(precio_poderGolpe)


func _on_recuperación_de_energía_pressed():
	verificar_precio(precio_recuperacion)


func _on_rango_de_recogida_pressed():
	verificar_precio(precio_rango)
