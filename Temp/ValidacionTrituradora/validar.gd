extends Node

func _ready() -> void:
	call_deferred("validar")

func validar() -> void:
	PhysicsServer2D.set_active(true)
	var mundo := Node2D.new()
	get_tree().root.add_child(mundo)
	get_tree().current_scene = mundo
	var dinero = get_tree().root.get_node("Dinero")
	var inventario = get_tree().root.get_node("Inventario")
	var trituradora = load("res://Entidades/Estaciones/Trituradora/trituradora.tscn").instantiate()
	mundo.add_child(trituradora)
	var bolsa = load("res://Entidades/BolsaDeBasura/bolsa_de_basura.tscn").instantiate()
	bolsa.data = bolsa.data.duplicate()
	bolsa.data.valor = 37
	bolsa.position = Vector2(100, 0)
	mundo.add_child(bolsa)
	var dinero_inicial: float = dinero.dinero
	var peso_inicial: int = inventario.peso
	var valor_inicial: int = inventario.valor_de_basuras
	await get_tree().physics_frame
	var vuelo: Tween = bolsa.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	vuelo.tween_property(bolsa, "position", Vector2.ZERO, 0.5)
	await get_tree().create_timer(0.8).timeout
	if is_instance_valid(bolsa) or dinero.dinero != dinero_inicial + 37 or inventario.peso != peso_inicial or inventario.valor_de_basuras != valor_inicial:
		push_error("FALLO: deteccion, destruccion, pago o inventario incorrectos")
		get_tree().quit(1)
		return
	print("OK: bolsa detectada durante vuelo, eliminada, pago unico de 37 e inventario intacto")
	var segunda = load("res://Entidades/BolsaDeBasura/bolsa_de_basura.tscn").instantiate()
	segunda.position = Vector2(200, 0)
	segunda.data = segunda.data.duplicate()
	segunda.data.valor = 13
	mundo.add_child(segunda)
	trituradora.recibir_basura_fisica(segunda)
	trituradora.recibir_basura_fisica(segunda)
	if dinero.dinero != dinero_inicial + 50:
		push_error("FALLO: pago duplicado")
		get_tree().quit(1)
		return
	print("OK: procesamiento repetido no duplica pago")
	get_tree().quit(0)






