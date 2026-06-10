@icon("res://addons/iconos/muerte.svg")
class_name MuerteComponente extends Node

@export var vida_componente: VidaComponente
@export var loot_componente: LootComponente
@export var animacion_muerte: String = "morir"
@export var tiempo_eliminacion: float = 0.5
@export var sonido_muerte: AudioStream


func _ready():
	comprobar_dependencias()


func comprobar_dependencias():
	# vida
	if not vida_componente: # si no tiene asignado en el inspector, asignalo
		vida_componente = get_owner().get_node_or_null("VidaComponente")

	if vida_componente:
		vida_componente.murio.connect(_on_murio)

	if not loot_componente: # si no tiene asignado en el inspector, asignalo
		loot_componente = get_owner().get_node_or_null("LootComponente")


func _on_murio():
	loot_componente.spawn_loot_drop()
	#SignalBus.emit_signal("quitar_del_array", self)
	owner.queue_free() #owner es la raiz de la escena, el enemigo


func _on_vida_componente_murio():
	_on_murio()
