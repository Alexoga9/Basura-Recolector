class_name LootDefinicion extends Resource

@export_group("Escena")
#@export var escena: PackedScene
@export var id: String
@export var nombre: String
#@export var tags: String
@export var audio: AudioStream
@export var sprite: Texture2D
@export var cantidad_maxima: int

@export_group("Tipo de objeto")
enum TipoElemento {BASURA, MATERIAL, COFRE, OBSTACULO}
@export var tipo_de_elemento: TipoElemento
enum TipoBasura {BASICO, PESADO}

@export_subgroup("Si es basura")
@export var tipo_de_basura: TipoBasura
@export var valor: int

@export_group("Requisitos")
@export var tiene_requisito: bool = false
enum TipoRequisito {RECOGIDA, FUERZA}#De referencia de momento
@export var tipo_de_requisito: TipoRequisito
@export var nivel_de_requisito: int


func settear_valores_del_loot(loot:Node2D, posicion:CharacterBody2D):
	if loot != null:
		loot.id = id
		loot.nombre = nombre
		loot.tipo_de_basura = tipo_de_basura
		loot.valor = valor
		#loot.tags = tags
		loot.audio = audio
		loot.sprite = sprite
		loot.global_position = posicion.global_position
