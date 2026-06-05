@icon("res://addons/iconos/Hitbox.svg")
class_name Hitbox extends Area2D

enum HitModo {UNICO, PENETRANTE, PULSANTE}
@export var modo: HitModo
@export var max_hits: int = 2 # hits antes de morir
@export var pulso_en_intervalos: float = 0.5
@export var pulso_multiplicador_daño: float = 1.0

@export var ignorar_misma_entidad: bool = true # No dañar al mismo enemigo dos veces

@onready var estado: HitboxState = %HitBoxState
@onready var padre = get_parent()

var already_hit: Array[Node] = [] # Enemigos ya golpeados (para pulsing)

signal iniciado
# Señal para modo pulsing
signal pulso_activado


#func _ready():
	#print("D: " +str(modo))
	#iniciado.emit()


func set_modo_penetracion():

	modo = HitModo.PULSANTE
	print("F:" + str(modo))


# timer
func _on_pulso_activado():
	# En modo pulsing, se limpia la lista de golpeados al activarse cada pulso
	already_hit.clear()
	get_parent().modulate = Color(0.0, 0.0, 0.0, 0.416)


func _on_hurtbox_entered(hurtbox: Area2D):
	print(str(max_hits) + " esta es max hits")
	print(self.name + " esta tocando a " + hurtbox.get_owner().name)
	var enemigo = hurtbox.get_parent()

	# Evita golpear al mismo enemigo dos veces (para pulsos)
	if ignorar_misma_entidad and enemigo in already_hit:
		return

	# Marca como golpeado
	already_hit.append(enemigo)

	# Notifica al estado que se hizo un hit
	estado.on_hit_enemigo(enemigo)

	if padre.daño_primario != null:
		hurtbox.recibir_golpe(padre.daño_primario)
		#print(padre.daño_primario)
