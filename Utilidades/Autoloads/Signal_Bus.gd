@tool
extends Node

# energia del jugador
signal energia_jugador_cambiada(valor)
signal energia_maxima_jugador_cambiada(valor)
signal murio_jugador

# Jugador
signal jugador_listo
signal input_movimiento

# Input
signal recoger_basura_automatica(bool)

# Basura
signal basura_recogida
signal click_basura(objeto)

# UI
# # Tienda 
signal mostrar_tienda
signal ocultar_tienda

# # Pausa 
signal juego_pausado
signal juego_reanudado

# # HUD
signal mostrar_hud

# # Menu Principal
signal mostrar_menu_principal

# # Opciones
