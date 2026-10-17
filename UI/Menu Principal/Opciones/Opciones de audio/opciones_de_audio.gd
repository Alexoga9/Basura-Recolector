extends Control

@export var panel_opciones: Control

@onready var master_slider: Slider = %MasterSlider
@onready var musica_slider: Slider = %MusicaSlider
@onready var sfx_slider: Slider = %SfxSlider


func _ready():
	# Inicializar los sliders con los valores actuales
	master_slider.value = Ajustes.volumen_master
	musica_slider.value = Ajustes.volumen_musica
	sfx_slider.value = Ajustes.volumen_sfx


func _on_master_slider_value_changed(value: float) -> void:
	Ajustes.volumen_master = value
	Ajustes.aplicar_volumen("Master", value)
	Ajustes.guardar()


func _on_musica_slider_value_changed(value: float) -> void:
	Ajustes.volumen_musica = value
	Ajustes.aplicar_volumen("Musica", value)
	Ajustes.guardar()


func _on_sfx_slider_value_changed(value: float) -> void:
	Ajustes.volumen_sfx = value
	Ajustes.aplicar_volumen("SFX", value)
	Ajustes.guardar()


func _on_atras_pressed():
	hide()
	panel_opciones.show()
