@icon("res://addons/iconos/Radar.svg")
class_name RadarComponente extends Area2D

var entidades: Array[Loot]
var cuerpos: Array[Basura]

var centro = global_position


func _ready():
	# area
	area_entered.connect(entidad_dentro_de_radar)
	area_exited.connect(entidad_fuera_de_radar)
	# body
	#body_entered.connect(entidad_dentro_de_radar)
	#body_exited.connect(entidad_fuera_de_radar)


func entidad_dentro_de_radar(area: Loot):
	#print(area.get_parent().name + " Ha entrado en el radar")
	entidades.append(area)
	area.objetivo = Global.jugador
	print(str(area.objetivo))


func entidad_fuera_de_radar(area: Loot):
	#print(area.get_parent().name + " Ha salido del radar")
	entidades.erase(area)


# ironicamente, no da la entidad más cercana
func get_entidad_mas_cercana() -> Loot:
	var mas_cercana = null
	var distancia_minima = INF

	for area in entidades:
		var distancia = centro.distance_to(area.global_position)

		if distancia < distancia_minima:
			distancia_minima = distancia
			mas_cercana = area

	return mas_cercana


func get_entidad_mas_lejana() -> Loot:
	var mas_lejana = null
	var distancia_maxima = -1 # Empieza con -1 (cualquier distancia será mayor)

	for entidad in entidades:
		var distancia = centro.distance_to(entidad.global_position)

		if distancia > distancia_maxima: # ← Cambias < por >
			distancia_maxima = distancia
			mas_lejana = entidad

	return mas_lejana


func get_entidad_aleatoria() -> Loot:
	if entidades.is_empty():
		return null

	var indice = randi() % entidades.size() # usa % para conseguir un numero valido 
	return entidades[indice]
