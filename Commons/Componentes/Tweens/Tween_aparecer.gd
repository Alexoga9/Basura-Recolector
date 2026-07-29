class_name TweenAparecer extends Node

var padre: Node2D
var tween_activo: Tween = null # 📌 Guardamos el Tween en ejecución


func _ready():
	padre = get_parent()


func aparecer() -> Tween:
	# 🔥 Matamos cualquier Tween anterior que esté corriendo
	if tween_activo and tween_activo.is_valid():
		tween_activo.kill()

	tween_activo = get_tree().create_tween()
	tween_activo.set_parallel()

	tween_activo.tween_property(self, "position", self.position + Vector2(0, -5), 1)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)

	tween_activo.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)

	return tween_activo


func esconder() -> Tween:
	# 🔥 Matamos cualquier Tween anterior que esté corriendo
	if tween_activo and tween_activo.is_valid():
		tween_activo.kill()

	tween_activo = get_tree().create_tween()
	tween_activo.set_parallel()

	tween_activo.tween_property(self, "position", self.position + Vector2(0, 5), 1)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)

	tween_activo.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)

	return tween_activo
