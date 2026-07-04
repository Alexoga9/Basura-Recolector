extends Panel

@onready var imagen = %imagen
@onready var nombre = %nombre
@onready var linea = %linea
@onready var descripcion = %descripcion
@onready var nivel = %nivel
@onready var barra = %barra
@onready var boton = %boton
@onready var precio = %precio

@export var mejora: DatosHabilidades


# Called when the node enters the scene tree for the first time.
func _ready():
	settear_valores()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func settear_valores():
	imagen.texture = mejora.imagen
	nombre.text = mejora.nombre
	descripcion.text = mejora.descripcion
	precio.text = str(mejora.precio)
