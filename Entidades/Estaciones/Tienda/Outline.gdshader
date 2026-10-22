shader_type canvas_item;

uniform float outline_width = 1.0;
uniform vec4 outline_color : source_color;
uniform vec4 texture_region = vec4(0.0);

float mascara_region(vec2 uv, vec4 region) {
	vec2 limite = region.xy + region.zw;
	if (uv.x < region.x || uv.y < region.y || uv.x >= limite.x || uv.y >= limite.y) {
		return 0.0;
	}
	return 1.0;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 outline_offset = vec2(outline_width) * TEXTURE_PIXEL_SIZE;
	vec4 uv_region = vec4(texture_region.xy * TEXTURE_PIXEL_SIZE, texture_region.zw * TEXTURE_PIXEL_SIZE);

	// If texture region size was not specified, then use entire texture
	uv_region.zw = mix(vec2(1.0), uv_region.zw, ceil(uv_region.zw));

	float uv_offset;
	float a;
	float max_a = 0.0;

	uv_offset = UV.y - outline_offset.y;
	a = mascara_region(vec2(UV.x, uv_offset), uv_region) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	max_a = max(a, max_a);

	uv_offset = UV.y + outline_offset.y;
	a = mascara_region(vec2(UV.x, uv_offset), uv_region) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	max_a = max(a, max_a);

	uv_offset = UV.x - outline_offset.x;
	a = mascara_region(vec2(uv_offset, UV.y), uv_region) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	max_a = max(a, max_a);

	uv_offset = UV.x + outline_offset.x;
	a = mascara_region(vec2(uv_offset, UV.y), uv_region) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	max_a = max(a, max_a);

	COLOR = mix(color, outline_color, clamp(max_a - color.a, 0.0, 1.0));
}
