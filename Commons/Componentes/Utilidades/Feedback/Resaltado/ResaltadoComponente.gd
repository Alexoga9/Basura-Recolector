@icon("res://addons/iconos/highlighter.svg")
class_name ResaltadoComponente extends Node

@export var trigger_area: Area2D
@export var material_outline: Material
@export var e_sprite: TweenAparecer
var estado_original_material: Material = null
var sprite_objetivo: Sprite2D
var objetivo_visual: Node2D


func _ready():
	sprite_objetivo = get_parent() as Sprite2D
	if not sprite_objetivo:
		sprite_objetivo = get_parent().get_node_or_null("Sprite") as Sprite2D
	objetivo_visual = sprite_objetivo if sprite_objetivo else get_parent() as Node2D
	if objetivo_visual:
		estado_original_material = objetivo_visual.material
		if material_outline:
			material_outline = material_outline.duplicate()
	if sprite_objetivo:
		sprite_objetivo.texture_changed.connect(_actualizar_region)
		_actualizar_region()


func resaltado():
	# if not is_inside_tree(): return
	_outline_on()
	_mostrar_e()


func no_resaltado():
	if not is_inside_tree(): return
	_ocutlar_e()
	_outline_off()


func _outline_on():
	if objetivo_visual and material_outline:
		objetivo_visual.material = material_outline


func _outline_off():
	if objetivo_visual:
		# Restauramos el material original (si tenía) o lo ponemos a null
		objetivo_visual.material = estado_original_material


func _actualizar_region() -> void:
	if not material_outline is ShaderMaterial or not sprite_objetivo.texture:
		return
	var region := Vector4.ZERO
	if sprite_objetivo.texture is AtlasTexture:
		var rect: Rect2 = sprite_objetivo.texture.region
		region = Vector4(rect.position.x, rect.position.y, rect.size.x, rect.size.y)
	elif sprite_objetivo.region_enabled:
		var rect := sprite_objetivo.region_rect
		region = Vector4(rect.position.x, rect.position.y, rect.size.x, rect.size.y)
	material_outline.set_shader_parameter("texture_region", region)


func _mostrar_e():
	if e_sprite:
		e_sprite.visible = true
		e_sprite.aparecer()


func _ocutlar_e():
	if e_sprite:
	# 1. Guardamos el Tween que devuelve esconder()
		var tween = e_sprite.esconder()

		# 2. ESPERAMOS a que el Tween termine
		await tween.finished

		# 3. Ahora que el Tween terminó, ocultamos el sprite
		e_sprite.visible = false
