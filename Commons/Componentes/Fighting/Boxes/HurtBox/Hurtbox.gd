@icon("res://addons/iconos/Hurtbox.svg")
class_name Hurtbox extends Area2D

@export var daño_componente: VidaComponente
signal daño_recibido(daño)
signal knockback_recibido(knockback)
signal estado_recibido(estado)


func _on_area_entered(area):
	print_rich("[color=red][shake]" +area.get_parent().name+"[/shake][/color]" + " daño a "+ "[color=green]" + self.get_parent().name+ "[/color]")
	#recibir_golpe(area.hit_data.daño)


# En el receptor
func recibir_golpe(datos):
	#print("me dieron " + str(datos))
	daño_recibido.emit(datos)

	## Knockback opcional - usa "in"
	#if datos.knockback != null:
		#aplicar_knockback(datos.knockback)


func aplicar_knockback(datos):
	knockback_recibido.emit(datos)
