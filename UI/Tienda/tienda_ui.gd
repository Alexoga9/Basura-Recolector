extends Control

@export var precio_resistencia: int
@export var precio_velocidadRecogida: int
@export var precio_lanzamiento: int
@export var precio_poderGolpe: int
@export var precio_recuperacion: int
@export var precio_rango: int

@onready var label_resistencia_de_energía = %"Label Resistencia de Energía"
@onready var label_velocidad_de_recolección = %"Label Velocidad de recolección"
@onready var label_poder_de_lanzamiento = %"Label Poder de lanzamiento"
@onready var label_poder_de_golpe = %"Label Poder de golpe"
@onready var label_recuperación_de_energía = %"Label Recuperación de Energía"
@onready var label_rango_de_recogida = %"Label Rango de recogida"


# Called when the node enters the scene tree for the first time.
func _ready():
	settear_precios()


func settear_precios():
	label_resistencia_de_energía.text = str(precio_resistencia)
	label_velocidad_de_recolección.text = str(precio_velocidadRecogida)
	label_poder_de_lanzamiento.text = str(precio_lanzamiento)
	label_poder_de_golpe.text = str(precio_poderGolpe)
	label_recuperación_de_energía.text = str(precio_recuperacion)
	label_rango_de_recogida.text = str(precio_rango)


func verificar_precio(precio:int):
	Inventario.modify_wallet_value(precio)
	precio *= 1.4
	settear_precios()
	if Dinero.dinero >= precio:
		Inventario.modify_wallet_value(precio)
		precio *= 1.4
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
