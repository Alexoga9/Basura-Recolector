class_name ComponenteGeneradorLoot extends Node

@export var loot: PackedScene
@onready var basura: Basura = $".."


## Este codigo es similar a TDeslizar, pero aqui lo usamos en local
func posición_en_radio(nodo: Node2D):
	randomize()
	var radio: float = 20.0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(nodo, "position", (nodo.position + Vector2(randf_range(-radio,radio), randf_range(-radio,radio))), 1)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_EXPO)


func spawnear_materiales():
	# Solo aplica a paquetes
	var es_paquete := basura.data.tipo_de_elemento == basura.data.TipoElemento.PAQUETE

	if not es_paquete:
		return

	# Un Loot por cada material dentro
	for material in basura.data.materiales_dentro:
		var nuevo_loot: Loot = loot.instantiate()
		nuevo_loot.data = material

		get_tree().get_first_node_in_group("EntidadesLoot").add_child(nuevo_loot)
		nuevo_loot.global_position = basura.global_position
		posición_en_radio(nuevo_loot)
