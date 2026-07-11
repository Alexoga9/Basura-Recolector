extends HBoxContainer

@export var textura: Texture2D
@onready var icono = %Icono
@onready var label = %Label


# Called when the node enters the scene tree for the first time.
func _ready():
	icono.texture = textura
	Dinero.valor_dinero_cambiado.connect(actualizar_dinero)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func actualizar_dinero(dinero:int):
	label.text = str(dinero)
