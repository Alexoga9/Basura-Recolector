@icon("res://addons/iconos/basura.svg")
class_name Basura extends StaticBody2D

@onready var sprite2d = %Sprite
@onready var collision_shape_2d = %CollisionShape2D
@onready var sonido: AudioStreamPlayer = %sonido_recogida
@onready var sonido_romper: AudioStreamPlayer = %sonido_romper

@onready var resaltado_componente: ResaltadoComponente = %ResaltadoComponente
@onready var t_recogida: TRecogida = %TRecogida
@onready var tween_rebote:TweenRebote = %TweenRebote

var id_guardado: String = ""
# 📌 EL COMPONENTE DE APILAMIENTO
@onready var componente_apilable: ComponenteApilable = %ComponenteApilable
@onready var componente_generador_loot: ComponenteGeneradorLoot = %ComponenteGeneradorLoot

@export var data: LootDefinicion

var objetivo = null
var en_area_jugador: bool = false
var input_recibido: bool = false
var recogida: bool = false
var golpes_restantes: int = -1

var id: String
var nombre: String
enum TipoBasura {BASICO, PESADO, PAQUETE}
var tipo_de_basura: TipoBasura
var valor: int

var requisito: bool
enum tipo_de_requisito_Enum {PICO, HACHA, AZADA}
var tipo_de_requisito: tipo_de_requisito_Enum
var nivel_requisito: int


func _ready():
	iniciar_valores()
	decidir_grupo()
	SignalBus.interaccion.connect(recibir_input)
	add_to_group("guardables")
	if id_guardado == "":
		id_guardado = get_tree().current_scene.name + "_" + name


func iniciar_valores():
	if golpes_restantes < 0:
		golpes_restantes = data.veces_a_golpear
	id = data.id
	nombre = data.nombre
	tipo_de_basura = int(data.tipo_de_basura)
	valor = data.valor
	sonido.stream = data.audio
	sprite_aleatorio()
	requisito = data.tiene_requisito
	tipo_de_requisito = int(data.tipo_de_requisito)
	nivel_requisito = data.nivel_de_requisito


func decidir_grupo():
	add_to_group("Basura")
	#match data.tipo_de_elemento:
		#data.TipoElemento.BASURA:
			#add_to_group("Basura")
#
		#data.TipoElemento.OBSTACULO:
			#add_to_group("Obstaculo")


func recibir_input():
	input_recibido = true


func collect():
	if recogida:
		return null
	recogida = true
	t_recogida.tween()
	sonido.play()
	collision_shape_2d.call_deferred("set", "disabled", true)
	componente_generador_loot.spawnear_materiales()

	Inventario.peso += 1
	Inventario.valor_de_basuras += valor
	SignalBus.basura_recogida.emit()

	return data


func romper():
	print("Golpeas " + str(Global.jugador.estadisticas_componente.golpe))
	golpes_restantes = maxi(0, golpes_restantes - Global.jugador.estadisticas_componente.golpe)
	sonido_romper.play()
	tween_rebote.tween()


func _on_sonido_finished():
	queue_free()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.jugador.radar_componente.click_en_basura(self)


func sprite_aleatorio():
	if data.conjunto_de_sprites:
		var random: int = randi_range(0, data.conjunto_de_sprites.size() - 1)
		sprite2d.texture = data.conjunto_de_sprites[random]
	else:
		sprite2d.texture = data.sprite
	if sprite2d.texture.get_height() > 32:
		# Mantener la base del arbol junto al collider.
		sprite2d.offset.y = 4.0 - sprite2d.texture.get_height() / 2.0
	var rect_sprite: Rect2 = sprite2d.get_rect()
	var detector: Area2D = $"Mouse Detector"
	detector.position = sprite2d.position + rect_sprite.get_center()
	var forma_mouse := RectangleShape2D.new()
	forma_mouse.size = rect_sprite.size
	detector.get_node("CollisionShape2D").shape = forma_mouse
	resaltado_componente.configurar_region(sprite2d.texture)


func obtener_datos() -> Dictionary:
	return {
		"global_position": global_position,
		"veces_a_golpear": golpes_restantes
	}


func aplicar_datos(datos: Dictionary) -> void:
	if datos.has("recogida") and datos["recogida"] == true:
		queue_free()


func serializar_estado() -> Dictionary:
	return {"golpes_restantes": golpes_restantes}


func restaurar_estado(datos: Dictionary) -> void:
	golpes_restantes = maxi(0, int(datos.get("golpes_restantes", data.veces_a_golpear)))


#func ser_recogida():
	#SaveGame.registrar_item_destruido(id_guardado)
	#queue_free()
