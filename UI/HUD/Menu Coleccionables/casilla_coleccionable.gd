extends Control

@export var nombre: String
@export var imagen: Texture2D
@onready var imagen_coleccionable: TextureRect = %"Imagen Coleccionable"
#var nombre_coleccionable: String


# Called when the node enters the scene tree for the first time.
func _ready():
	imagen_coleccionable.texture = imagen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	revisar_coleccionable_en_inventario()


func revisar_coleccionable_en_inventario():
	if Inventario.has_item(nombre, 1):
		print("Coleccionable Adquirido")
		imagen_coleccionable.modulate = Color.WHITE
