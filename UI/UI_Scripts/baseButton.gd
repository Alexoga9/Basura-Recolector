extends Control
var button = Button
@onready var start_button: Button = $MarginContainer/VBoxContainer/start_button
@onready var settings_button: Button = $MarginContainer/VBoxContainer/settings_button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/quit_button


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mundo.tscn")
