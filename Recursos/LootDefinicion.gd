class_name LootDefinicion extends Resource

@export var id: String
@export var nombre: String
enum TipoLoot {EXPERIENCIA, VIDA, DINERO, POWER_UP}
@export var tipo_de_loot: TipoLoot
@export var valor: int

@export var escena: PackedScene
@export var tags: String
@export var audio: AudioStream
@export var sprite: Texture2D


func settear_valores_del_loot(loot:Node2D, posicion:CharacterBody2D):
	if loot != null:
		loot.id = id
		loot.nombre = nombre
		#loot.tipo_de_loot = tipo_de_loot
		loot.valor = valor
		loot.tags = tags
		loot.audio = audio
		loot.sprite = sprite
		loot.global_position = posicion.global_position
