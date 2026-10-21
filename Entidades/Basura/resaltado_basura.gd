extends ResaltadoComponente
## El radar decide que objeto resaltar; otras areas no activan el outline.


func configurar_region(textura: Texture2D) -> void:
	if material_outline is ShaderMaterial:
		material_outline = material_outline.duplicate()
		var region := Vector4.ZERO
		if textura is AtlasTexture:
			var rect: Rect2 = textura.region
			region = Vector4(rect.position.x, rect.position.y, rect.size.x, rect.size.y)
		material_outline.set_shader_parameter("texture_region", region)
