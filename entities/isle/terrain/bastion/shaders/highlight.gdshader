shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float line_smoothness : hint_range(0, 0.1) = 0.045;
uniform float line_width : hint_range(0, 0.2) = 0.09;
uniform float brightness = 3.0;
uniform float rotation_deg : hint_range(-90, 90) = 30;
uniform float distortion : hint_range(1, 2) = 1.8;
uniform float speed = 0.7;
uniform float position : hint_range(0, 1) = 0;
uniform float position_min = 0.25;
uniform float position_max = 0.5;
uniform float alpha : hint_range(0, 1) = 1;

vec2 rotate_uv(vec2 uv, vec2 center, float rotation, bool use_degrees){
	float angle = rotation;
	if(use_degrees){
		angle = rotation * (3.1415926/180.0);
	}
	mat2 rotation_matrix = mat2(
		vec2(cos(angle), -sin(angle)),
		vec2(sin(angle), cos(angle))
	);
	vec2 delta = uv - center;
	delta = rotation_matrix * delta;
	return delta + center;
}

void fragment() {
	
	vec2 center_uv = UV - vec2(0.5, 0.5);
	float gradient_to_edge = max(abs(center_uv.x), abs(center_uv.y));
	gradient_to_edge = gradient_to_edge * distortion;
	gradient_to_edge = 1.0 - gradient_to_edge;
	vec2 rotated_uv = rotate_uv(UV, vec2(0.5, 0.5), rotation_deg, true);
	
	float remapped_position;
	{
		float output_range = position_max - position_min;
		remapped_position = position_min + output_range * position;
	}
	
	float remapped_time = TIME * speed + remapped_position;
	remapped_time = fract(remapped_time);
	{
		float output_range = 2.0 - (-2.0);
		remapped_time = -2.0 + output_range * remapped_time;
	}
	
	vec2 offset_uv = vec2(rotated_uv.xy) + vec2(remapped_time, 0.0);
	float line = vec3(offset_uv, 0.0).x;
	line = abs(line);
	line = gradient_to_edge * line;
	line = sqrt(line);
	
	float line_smoothness_clamped = clamp(line_smoothness, 0.001, 1.0);
	float offset_plus = line_width + line_smoothness_clamped;
	float offset_minus = line_width - line_smoothness_clamped;
	
	float remapped_line;
	{
		float input_range = offset_minus - offset_plus;
		remapped_line = (line - offset_plus) / input_range;
	}
	remapped_line = remapped_line * brightness;
	remapped_line = min(remapped_line, alpha);
	COLOR.rgb = vec3(COLOR.xyz) * vec3(remapped_line);
	COLOR.a = remapped_line;
}
