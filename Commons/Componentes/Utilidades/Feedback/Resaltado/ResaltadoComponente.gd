class_name ResaltadoComponente extends Node

@export var material_outline: Material
@export var e_sprite: AnimatedSprite2D
var estado_original_material: Material = null


func _ready():
	# 1. Guardamos el material original del padre (NO lo modificamos aún)
	if get_parent() is Node2D:
		estado_original_material = get_parent().material

	# 2. Esperamos 1 frame para que el nodo esté completamente establecido
	await get_tree().process_frame

	# 3. Ahora sí, forzamos el estado inicial DESACTIVADO
	#no_resaltado()


func resaltado():
	#if not is_inside_tree(): return
	_outline_on()
	_mostrar_e()


func no_resaltado():
	if not is_inside_tree(): return
	_outline_off()
	_ocutlar_e()


func _outline_on():
	if get_parent() is Node2D and material_outline:
		get_parent().material = material_outline


func _outline_off():
	if get_parent() is Node2D:
		# Restauramos el material original (si tenía) o lo ponemos a null
		get_parent().material = estado_original_material


func _mostrar_e():
	if e_sprite:
		e_sprite.visible = true


func _ocutlar_e():
	if e_sprite:
		e_sprite.visible = false
