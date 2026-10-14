class_name DataValla extends Resource

## porcentaje requerido minimo
@export var porcentaje_requerido: int = 0
## escena a la que va cambiar
@export var siguiente: String
@export var costo: int

## 1 arriba
## 2 izquierda
## 3 derecha
## 4 abajo
@export var entrada: int
## Esta esta puerta abierta?
@export var condicion: bool
