extends Control

@onready var imagen = %imagen
@onready var nombre = %nombre
@onready var linea = %linea
@onready var descripcion = %descripcion
@onready var label_nivel = %nivel
@onready var barra = %barra
@onready var boton = %boton
@onready var label_precio = %precio

@export var mejora: DatosHabilidades
@export var logica_mejora: Logica_Mejora

var nivel: int = 0
var precio: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	_settear_valores_iniciales()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_habilitador_de_componentes()


func _settear_valores_iniciales():
	imagen.texture = mejora.imagen
	nombre.text = mejora.nombre
	descripcion.text = mejora.descripcion
	label_precio.text = str(mejora.precio)
	precio = mejora.precio


func _confirmar_logica():
	if logica_mejora == null:
		print(mejora.nombre + "No tiene logica")


func _habilitador_de_componentes():
	if Dinero.dinero < precio:
		boton.disabled = true
	else:
		boton.disabled = false


func _comprar_mejora():
	Dinero.dinero -= precio #Cambiar por el base
	nivel += 1
	_actualizar_barra_de_progreso()
	_actualizar_precio()


func _actualizar_precio():
	precio *= 1.7
	precio = int(precio)
	label_precio.text = str(precio)


func _actualizar_barra_de_progreso():
	barra.value = nivel


func _on_boton_pressed():
	_comprar_mejora()
