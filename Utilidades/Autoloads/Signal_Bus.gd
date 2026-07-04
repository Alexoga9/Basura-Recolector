@tool
extends Node

# energia del jugador
signal energia_jugador_cambiada(valor)
signal energia_maxima_jugador_cambiada(valor)
signal murio_jugador

# experiencia del jugador
signal valor_xp_cambiado(valor)
signal valor_xp_maximo_cambiado(valor)
signal subir_de_nivel(valor)

# wave manager
signal enemigo_matado

# Jugador
signal jugador_listo
signal input_movimiento

# Input
signal recoger_basura_automatica(bool)

# Basura
signal basura_recogida

# Tienda 
signal mostrar_tienda
signal ocultar_tienda
