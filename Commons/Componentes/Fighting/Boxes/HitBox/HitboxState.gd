@icon("res://addons/iconos/Hitbox State.svg")
class_name HitboxState extends Node

# Para PENETRANTE

var current_hits: int = 0

# Para PULSANTE
var pulso_timer: Timer
var es_PULSANTE: bool = true

# Referencia al hitbox
@onready var hitbox: Hitbox = get_parent()
@onready var collision = %CollisionShape2D # debo cambiar esto para encontrarlo como hijo


func crear_timer_PULSANTE():
	pulso_timer = Timer.new()
	pulso_timer.wait_time = hitbox.pulso_en_intervalos
	pulso_timer.autostart = true
	pulso_timer.timeout.connect(_on_pulso_timeout)
	add_child(pulso_timer)


func _on_pulso_timeout():
	if not es_PULSANTE:
		return

	# Activa/desactiva colisión en cada pulso
	collision.disabled = not collision.disabled

	if not collision.disabled:
		# Cuando se activa, emite señal para que el hitbox procese
		hitbox.pulso_activado.emit()


func on_hit_enemigo(enemy: Node):
	if hitbox.modo == hitbox.HitModo.UNICO:
		disable_hitbox()
	elif hitbox.modo == hitbox.HitModo.PENETRANTE:
		current_hits += 1
		print(str(current_hits) + "current_hits")

		if current_hits >= hitbox.max_hits:
			disable_hitbox()


func disable_hitbox():
	collision.call_deferred("set", "disabled", true)
	hitbox.call_deferred("set", "monitoring", false)
	# Opcional: queue_free() si es un proyectil temporal
	get_parent().get_parent().queue_free()


func _on_hitbox_iniciado():
	#hitbox.modo = hitbox.HitModo.PULSANTE

	match hitbox.modo:
		hitbox.HitModo.UNICO:
			print("UNICOOO")
			return

		hitbox.HitModo.PULSANTE:
			print("TIMER HITBOX")
			crear_timer_PULSANTE()
			print("un solo golpe")
			return

		hitbox.HitModo.PENETRANTE:

			print("varios golpes")
			return
