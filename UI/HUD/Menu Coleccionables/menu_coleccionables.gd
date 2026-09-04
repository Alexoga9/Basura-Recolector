extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.input_tab.connect(desglosar_menu_coleccionable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func desglosar_menu_coleccionable():

	if visible:
		hide()
	else:
		show()
