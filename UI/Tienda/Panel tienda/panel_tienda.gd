class_name PanelTienda extends Control

@onready var imagen: TextureRect = %imagen
@onready var nombre: Label = %nombre
@onready var descripcion: Label = %descripcion
@onready var label_nivel: Label = %nivel
@onready var barra: ProgressBar = %barra
@onready var boton: Button = %boton
@onready var label_precio: Label = %precio
@onready var audio: AudioStreamPlayer = %audio
@onready var beneficio: Label = %Beneficio
@onready var actual: Label = %Actual

@export var mejora: DatosHabilidades
@export var logica_mejora: Logica_Mejora

var nivel: int = 1
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
	logica_mejora.aplicar_mejora()
	Dinero.dinero -= precio #Cambiar por el base
	nivel += 1
	label_nivel.text = ("Nivel " + str(nivel))
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
	audio.play()


func estadisticas(ahora: float, buff: float):
	beneficio.text = str(ahora)
	actual.text = str(buff)
