class_name MaterialesNecesarios extends Resource

@export_group("Material")
enum Tipo_de_Material {
MADERA,
PIEDRA,
HIERRO,
ORO,
DINERO
}
@export var tipo_de_elemento: Tipo_de_Material

@export var cantidad_necesaria: int

@export var imagen: Texture2D
