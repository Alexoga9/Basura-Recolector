@icon("res://addons/iconos/apilable.svg")
class_name ComponenteApilable extends Node

# 📌 Exportamos los RayCasts (los arrastras desde el Inspector)
@export var ray_cast_abajo: RayCast2D
@export var ray_cast_arriba: RayCast2D

# 📌 Variables internas
var caja_debajo: StaticBody2D = null
var caja_arriba: StaticBody2D = null
var cayendo: bool = false
var altura_pila: int = 0
var cuerpo_padre: StaticBody2D = null


func _ready():
	cuerpo_padre = get_parent() as StaticBody2D

	# Configuramos los raycasts
	if ray_cast_abajo:
		ray_cast_abajo.enabled = true

	if ray_cast_arriba:
		ray_cast_arriba.enabled = true

	# Detectamos estado inicial
	detectar_caja_debajo()
	detectar_caja_arriba()


func _process(delta):
	# Si no estamos cayendo y no hay caja debajo, caemos
	if not cayendo and caja_debajo == null and altura_pila > 0:
		caer_al_siguiente_nivel()


# 📌 DETECCIÓN DE CAJA DEBAJO
func detectar_caja_debajo():
	if not ray_cast_abajo: return

	ray_cast_abajo.force_raycast_update()

	if ray_cast_abajo.is_colliding():
		var colision = ray_cast_abajo.get_collider()

		if colision != cuerpo_padre and colision is StaticBody2D:
			caja_debajo = colision

			if caja_debajo.has_method("get_altura_pila"):
				altura_pila = caja_debajo.get_altura_pila() + 1
			else:
				altura_pila = 1

			cuerpo_padre.z_index = caja_debajo.z_index + 1
			return

	caja_debajo = null
	altura_pila = 0
	cuerpo_padre.z_index = 0


# 📌 DETECCIÓN DE CAJA ARRIBA
func detectar_caja_arriba():
	if not ray_cast_arriba: return

	ray_cast_arriba.force_raycast_update()

	if ray_cast_arriba.is_colliding():
		var colision = ray_cast_arriba.get_collider()

		if colision != cuerpo_padre and colision is StaticBody2D:
			caja_arriba = colision
			return

	caja_arriba = null


# 📌 CAÍDA
func caer_al_siguiente_nivel():
	if cayendo or cuerpo_padre == null:
		return

	cayendo = true

	var tween = create_tween()
	tween.tween_property(cuerpo_padre, "global_position",
		Vector2(cuerpo_padre.global_position.x, cuerpo_padre.global_position.y + 5), 0.1)

	tween.tween_callback(func():
		cayendo = false

		if caja_arriba != null and caja_arriba.has_method("detectar_caja_debajo"):
			caja_arriba.detectar_caja_debajo()

		detectar_caja_debajo()
		detectar_caja_arriba()

	)


func get_altura_pila() -> int:
	return altura_pila


# 📌 EXPONEMOS LAS FUNCIONES PÚBLICAS PARA QUE EL PADRE PUEDA LLAMARLAS
func forzar_deteccion():
	detectar_caja_debajo()
	detectar_caja_arriba()
