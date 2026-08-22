extends Node

@onready var sprite_sucio = %sucio
@onready var sprite_limpio = %limpio


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(sprite_limpio, "modulate:a", 0, 0)

	SignalBus.zona_limpida.connect(zonas_limpias)


func zonas_limpias():
	var tween = create_tween()
	tween.tween_property(sprite_sucio, "modulate:a", 0.0, 1.5)
	tween.tween_property(sprite_limpio, "modulate:a", 1.0, 1.5)


func _on_button_pressed() -> void:
	SignalBus.zona_limpida.emit()
