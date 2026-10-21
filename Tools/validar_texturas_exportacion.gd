extends SceneTree
## Ejecutar tambien con --main-pack para comprobar los recursos exportados.

var errores: int = 0


func _initialize() -> void:
	validar.call_deferred()


func comprobar_textura(textura: Texture2D, nombre: String) -> void:
	if textura == null or textura.get_width() <= 0 or textura.get_height() <= 0:
		errores += 1
		push_error("Textura ausente o vacia: " + nombre)
	elif textura is AtlasTexture:
		comprobar_textura(textura.atlas, nombre + "/atlas")


func validar() -> void:
	var tema = load("res://UI/Theme/Tienda.tres")
	for estado in ["normal", "hover", "pressed", "disabled"]:
		comprobar_textura(tema.get_stylebox(estado, "Button").texture, "Button/" + estado)
	for estado in ["grabber", "grabber_highlight", "grabber_pressed"]:
		comprobar_textura(tema.get_stylebox(estado, "VScrollBar").texture, "VScrollBar/" + estado)
	for habilidad in ["cooldown", "fuerza", "lanzamiento", "peso", "rango", "resistencia"]:
		var datos = load("res://UI/Tienda/mejoras de habilidades/Datos Habilidades/datos_habilidades_%s.tres" % habilidad)
		comprobar_textura(datos.imagen, habilidad)
	var barras = load("res://UI/Barras/barras_hud.tscn")
	if barras == null or not barras.can_instantiate():
		errores += 1
		push_error("No se puede cargar la escena de barras")
	print("Validacion texturas UI: %d errores" % errores)
	quit(0 if errores == 0 else 1)
