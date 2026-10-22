class_name LootDefinicion extends Resource

@export_group("Escena")
@export var id: String
@export var nombre: String
@export var audio: AudioStream
@export var sprite: Texture2D
@export var conjunto_de_sprites: Array[Texture2D]
@export var cantidad_maxima: int

@export_group("Presentacion en el mundo")
enum PerfilMundo {CAJA, ARBOL, PIEDRA, HIERBA, PERSONALIZADO}
@export var perfil_mundo: PerfilMundo = PerfilMundo.CAJA
@export var forma_colision: Shape2D
@export var posicion_colision: Vector2 = Vector2.ZERO
@export var desplazamiento_visual: Vector2 = Vector2.ZERO
@export var tamano_interaccion: Vector2 = Vector2.ZERO

@export_group("Tipo de objeto")
enum TipoElemento {BASURA,
MATERIAL,
PAQUETE,
OBSTACULO,
BOLSA_DE_BASURA,
COLECCIONABLE}
@export var tipo_de_elemento: TipoElemento
enum TipoBasura {BASICO, PESADO}

@export_subgroup("Si es basura")
@export var tipo_de_basura: TipoBasura
@export var valor: int

@export_subgroup("Si es basura pesada")
@export var veces_a_golpear: int

@export_group("Requisitos")
@export var tiene_requisito: bool = false
enum TipoRequisito {PICO, HACHA, AZADA}#De referencia de momento
@export var tipo_de_requisito: TipoRequisito
@export var nivel_de_requisito: int

@export_group("Paquete")
@export var materiales_dentro: Array[LootDefinicion]
