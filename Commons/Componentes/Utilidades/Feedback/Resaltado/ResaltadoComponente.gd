class_name ResaltadoComponente extends Node

@export var sprite: Sprite2D
@export var area: Area2D

@export var e_sprite: AnimatedSprite2D


func resaltado():
	sprite.frame = 1

	if e_sprite != null:
		e_sprite.visible = true


func no_resaltado():
	sprite.frame = 0

	if e_sprite != null:
		e_sprite.visible = false
