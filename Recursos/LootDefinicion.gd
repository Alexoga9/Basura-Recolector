class_name LootDefinicion extends Resource

@export var id: String
@export var nombre: String
enum TipoElemento {BASURA, MATERIAL, COFRE}
@export var tipo_de_elemento: TipoElemento
enum TipoBasura {BASICO, PESADO}
@export var tipo_de_basura: TipoBasura
@export var valor: int
@export var cantidad_maxima: int

# Hacer bool para que solo aparesca si corresponde
@export var tiene_requisito: bool
enum TipoRequisito {RECOGIDA, FUERZA}#De referencia de momento
@export var tipo_de_requisito: TipoRequisito
@export var nivel_de_requisito: int

@export var escena: PackedScene
@export var tags: String
@export var audio: AudioStream
@export var sprite: Texture2D


func settear_valores_del_loot(loot:Node2D, posicion:CharacterBody2D):
	if loot != null:
		loot.id = id
		loot.nombre = nombre
		loot.tipo_de_basura = tipo_de_basura
		loot.valor = valor
		loot.cantidad_maxima = cantidad_maxima
		loot.tags = tags
		loot.audio = audio
		loot.sprite = sprite
		loot.global_position = posicion.global_position
