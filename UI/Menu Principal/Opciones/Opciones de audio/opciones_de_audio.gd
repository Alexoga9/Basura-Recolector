extends Control

@export var panel_opciones: Control

@onready var MASTER_BUS_ID: int
@onready var MUSICA_BUS_ID: int
@onready var SFX_BUS_ID: int

@onready var master_slider = %MasterSlider
@onready var musica_slider = %MusicaSlider
@onready var sfx_slider = %SfxSlider


func _ready():
	buscar_ids_de_AudioBuses()


func buscar_ids_de_AudioBuses():
	MASTER_BUS_ID = AudioServer.get_bus_index("Master")
	MUSICA_BUS_ID = AudioServer.get_bus_index("Musica")
	SFX_BUS_ID = AudioServer.get_bus_index("SFX")


func controlar_sonido(ID, value):
	# Ajuste automatizado de canales de audio
	AudioServer.set_bus_volume_db(ID, linear_to_db(value))
	AudioServer.set_bus_mute(ID, value < 0.05)


func _on_atras_pressed():
	hide()
	panel_opciones.show()


func _on_master_slider_value_changed(value):
	controlar_sonido(MASTER_BUS_ID, value)


func _on_musica_slider_value_changed(value):
	controlar_sonido(MUSICA_BUS_ID, value)


func _on_sfx_slider_value_changed(value):
	controlar_sonido(SFX_BUS_ID, value)
