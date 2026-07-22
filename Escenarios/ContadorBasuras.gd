extends ProgressBar

var cantidad_de_basuras: int
var basuras_actuales: int
@onready var cleared: Label = %Cleared


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.basura_recogida.connect(contar_basura)
	cantidad_de_basuras = get_tree().get_node_count_in_group("Basura")
	print("Hay basuras" +str(cantidad_de_basuras))
	max_value = cantidad_de_basuras


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func contar_basura():
	basuras_actuales += 1
	value = basuras_actuales
