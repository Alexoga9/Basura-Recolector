class_name ResaltadoComponente extends Node

@export var sprite: Sprite2D
@export var area: Area2D

@export var highlight: Texture2D


func al_mouse_entrar():
	sprite.frame = 1


func al_mouse_salir():
	sprite.frame = 0
