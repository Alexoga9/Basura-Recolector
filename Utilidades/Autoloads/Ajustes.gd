extends Node

## Valores de configuración (0.0 a 1.0 para los volúmenes)
var volumen_master: float = 1.0
var volumen_musica: float = 1.0
var volumen_sfx: float = 1.0


func _ready():
	cargar()
	aplicar_todo()


## Aplica todos los ajustes a los sistemas correspondientes.
func aplicar_todo() -> void:
	aplicar_volumen("Master", volumen_master)
	aplicar_volumen("Musica", volumen_musica)
	aplicar_volumen("SFX", volumen_sfx)


func aplicar_volumen(nombre_bus: String, valor: float) -> void:
	var bus_id := AudioServer.get_bus_index(nombre_bus)

	if bus_id < 0:
		return

	AudioServer.set_bus_volume_db(bus_id, linear_to_db(valor))
	AudioServer.set_bus_mute(bus_id, valor < 0.05)

# ------------------------------------------------------------------
# Persistencia
# ------------------------------------------------------------------
const RUTA_SETTINGS := "user://settings.cfg"


func guardar() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master", volumen_master)
	config.set_value("audio", "musica", volumen_musica)
	config.set_value("audio", "sfx", volumen_sfx)

	var err := config.save(RUTA_SETTINGS)

	if err != OK:
		push_error("Error al guardar ajustes: ", err)


func cargar() -> void:
	var config := ConfigFile.new()
	var err := config.load(RUTA_SETTINGS)

	if err != OK:
		return # No hay archivo o está corrupto: usar valores por defecto

	volumen_master = config.get_value("audio", "master", 1.0)
	volumen_musica = config.get_value("audio", "musica", 1.0)
	volumen_sfx = config.get_value("audio", "sfx", 1.0)
