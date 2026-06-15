extends Control

@onready var start_button: Button = $MarginContainer/VBoxContainer/start_button
@onready var settings_button: Button = $MarginContainer/VBoxContainer/settings_button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/quit_button
@onready var setting_conteiner_mg_2: MarginContainer = $MainPanel/SettingConteinerMG2
@onready var main_conteiner_mg: MarginContainer = $MainPanel/MainConteinerMG
@onready var back_button: Button = $MainPanel/SettingConteinerMG2/Back_button


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mundo.tscn")


func _on_settings_button_pressed() -> void:
	main_conteiner_mg.hide()
	setting_conteiner_mg_2.show()


func _on_back_button_pressed() -> void:
	main_conteiner_mg.show()
	setting_conteiner_mg_2.hide()
