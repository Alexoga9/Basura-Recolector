@tool
extends Node

# energia del jugador
signal energia_jugador_cambiada(valor)
signal energia_maxima_jugador_cambiada(valor)
signal murio_jugador

# Jugador
signal jugador_listo
signal input_movimiento
signal interaccion

# Input
signal input_tab
signal input_esc
signal input_click
signal beber_refresco

# Basura
signal basura_recogida
signal zona_limpida(porcentaje: int)

# Recogibles
signal material_recogido

# Ckeckpoint 
signal entrada_de_checkpoint(entrada: int)

# UI
# # Tienda 
signal mostrar_tienda
signal ocultar_tienda

# # Pausa 
signal juego_pausado
signal juego_reanudado

# # HUD
signal mostrar_hud

# # Notificaciones
signal notificacion(texto: String)

# # Notas Coleccionables
signal notas_menu(DataNotas)

# # Valla
signal preguntar_pasar_por_valla(entrada:int)
signal pasar_entrada_valla(entrada:int)

# # Transicion
signal hacer_transicion
signal terminar_transicion

# # Menu Principal
signal mostrar_menu_principal

# # Opciones

# # Estacion Rota
signal actualizar_estacion_rota
