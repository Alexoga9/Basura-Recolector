extends Control

@export var nombre: String
@export var imagen: Texture2D
@onready var imagen_coleccionable: TextureRect = %"Imagen Coleccionable"
#var nombre_coleccionable: String


# Called when the node enters the scene tree for the first time.
func _ready():
	imagen_coleccionable.texture = imagen
	SignalBus.material_recogido.connect(revisar_coleccionable_en_inventario)


func revisar_coleccionable_en_inventario():
	if Inventario.has_item(nombre, 1):
		print("Coleccionable Adquirido")
		imagen_coleccionable.modulate = Color.WHITE
