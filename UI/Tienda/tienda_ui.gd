extends Control

@export var precio_resistencia: int
@export var precio_velocidadRecogida: int
@export var precio_lanzamiento: int
@export var precio_poderGolpe: int
@export var precio_recuperacion: int
@export var precio_rango: int

@onready var precio_resistencia_de_energía = %"Precio Resistencia de Energía"
@onready var nivel_resistencia_de_energía_2 = %"Nivel Resistencia de Energía2"

@onready var precio_velocidad_de_recolección = %"Precio Velocidad de recolección"
@onready var nivel_velocidad_de_recolección_2 = %"Nivel Velocidad de recolección2"

@onready var precio_poder_de_lanzamiento = %"Precio Poder de lanzamiento"
@onready var nivel_poder_de_lanzamiento_2 = %"Nivel Poder de lanzamiento2"

@onready var precio_poder_de_golpe = %"Precio Poder de golpe"
@onready var nivel_poder_de_golpe_2 = %"Nivel Poder de golpe2"

@onready var precio_recuperación_de_energía = %"Precio Recuperación de Energía"
@onready var nivel_recuperación_de_energía_2 = %"Nivel Recuperación de Energía2"

@onready var precio_rango_de_recogida = %"Precio Rango de recogida"
@onready var nivel_rango_de_recogida_2 = %"Nivel Rango de recogida2"


# Called when the node enters the scene tree for the first time.
func _ready():
	settear_precios()


func settear_precios():
	precio_resistencia_de_energía.text = str(precio_resistencia)
	precio_velocidad_de_recolección.text = str(precio_velocidadRecogida)
	precio_poder_de_lanzamiento.text = str(precio_lanzamiento)
	precio_poder_de_golpe.text = str(precio_poderGolpe)
	precio_recuperación_de_energía.text = str(precio_recuperacion)
	precio_rango_de_recogida.text = str(precio_rango)


func verificar_precio(precio:int):
	var precio_actual: int
	if Dinero.dinero >= precio:
		Inventario.modify_wallet_value(precio)
		precio_actual = precio * 1.4
		precio = precio_actual
		settear_precios()


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
