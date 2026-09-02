shader_type canvas_item;

uniform float angle = 0.0;
uniform float thickness = 0.01;
uniform vec2 center = vec2(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = 2. * UV - center;
	
	float slope = tan(angle);
	float line = uv.y - slope * uv.x;
	float distance_to_Line = abs(line) / sqrt(1. + slope * slope);
	float shine_mask = step(distance_to_Line, thickness);
	COLOR.rgb = mix(COLOR.rgb, vec3(1.), vec3(shine_mask));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
