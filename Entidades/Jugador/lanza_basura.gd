extends Node

@export var bolsa_de_basura: PackedScene
@export var data: LootDefinicion


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Lanzar_Basura"):
		datos_basura()
		spawnear()


func datos_basura():
	var cantidad_basura: int = Inventario.get_count("Basura")
	var valor_basura: int = Inventario.get_item_resource("Basura").valor
	var valor_de_venta: int = cantidad_basura*valor_basura

	data.valor = valor_basura
	Inventario.remove_item("Basura", cantidad_basura)


func spawnear():
	var nuevo = bolsa_de_basura.instantiate()
	nuevo.data = data
	nuevo.global_position = $"..".global_position + Vector2(0, 50)
	get_tree().current_scene.add_child(nuevo)
