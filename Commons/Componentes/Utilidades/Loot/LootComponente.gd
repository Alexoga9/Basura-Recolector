@icon("res://addons/iconos/gems.svg")
class_name LootComponente extends Node

@export var body: CharacterBody2D
@export var loot_unico: LootDefinicion
@export var loot: PackedScene


func si_muerto():
	spawn_loot_drop()


func spawn_loot_drop():
	var drop = loot.instantiate() #loot_unico.escena.instantiate()
	#loot_unico.settear_valores_del_loot(drop, body)
	drop.data = loot_unico
	drop.global_position = get_parent().global_position

	call_deferred("agregar_loot_al_mundo", drop)

	#get_tree().get_first_node_in_group("LootContainer").add_child(drop) #asi todo el loot va a una carpeta


func agregar_loot_al_mundo(drop: Node2D):
	var loot_container = get_tree().get_first_node_in_group("LootContainer")

	if loot_container:
		loot_container.add_child(drop)
