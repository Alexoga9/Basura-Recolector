@tool
extends Node

# vida del jugador
signal vida_jugador_cambiada(valor)
signal vida_maxima_jugador_cambiada(valor)
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
