class_name ComponenteGeneradorLoot extends Node

@export var loot: PackedScene
@onready var basura: Basura = $".."


func posición_en_radio(nodo: Node2D):
	randomize()
	var tween: TDeslizar = TDeslizar.new()
	tween.rango = 1.0
	tween.distancia = randf_range(-1, 1)
	nodo.add_child(tween)

	#var random_posicion: float = randf_range(-5, 5)
	#nodo.global_position += Vector2(random_posicion, random_posicion)


func spawnear_materiales():
	# Solo aplica a paquetes (ajusta el enum según tu caso)
	var es_paquete := basura.data.tipo_de_elemento == basura.data.TipoElemento.PAQUETE

	if not es_paquete:
		return

	# Un Loot por cada material dentro
	for material in basura.data.materiales_dentro:
		var nuevo_loot: Loot = loot.instantiate()
		nuevo_loot.data = material

		# Posicionar donde estaba la caja original

		# Añadir a la escena (elige un padre apropiado)
		get_tree().get_first_node_in_group("EntidadesLoot").add_child(nuevo_loot)
		nuevo_loot.global_position = basura.global_position
		posición_en_radio(nuevo_loot)
