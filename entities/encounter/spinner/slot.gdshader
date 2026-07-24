shader_type canvas_item;

uniform sampler2D tex_0;
uniform sampler2D tex_1;
uniform sampler2D tex_2;
uniform sampler2D tex_3;
uniform sampler2D tex_4;
uniform sampler2D tex_5;

uniform float x_offset = 0.0;
uniform float y_offset = 0.0;

uniform bool is_y = true;

int get_texture_index(int index) {
	return ((index % 6) + 6) % 6;
}

vec4 get_texture(int index, vec2 uv) {
	int idx = get_texture_index(index);
	
	if (idx == 0) return texture(tex_0, uv);
	else if (idx == 1) return texture(tex_1, uv);
	else if (idx == 2) return texture(tex_2, uv);
	else if (idx == 3) return texture(tex_3, uv);
	else if (idx == 4) return texture(tex_4, uv);
	else return texture(tex_5, uv);
}

void fragment() {
	vec2 uv = UV;
	
	float position = x_offset * 6.0;
	
	if (is_y) {
		position = y_offset * 6.0;
	}
	
	int current_index = int(floor(position)); 
	float blend = fract(position);
	
	vec4 color;
	
	if (is_y){
		if (uv.y < blend) {
			vec2 uv_next = uv + vec2(0.0, 1.0 - blend);
			int next_index = current_index + 1;
			color = get_texture(next_index, uv_next);
		} else {
			vec2 uv_current = uv - vec2(0.0, blend);
			color = get_texture(current_index, uv_current);
		}
	}
	else {
		if (uv.x < blend) {
			vec2 uv_next = uv + vec2(1.0 - blend, 0.0);
			int next_index = current_index + 1;
			color = get_texture(next_index, uv_next);
		} else {
			vec2 uv_current = uv - vec2(blend, 0.0);
			color = get_texture(current_index, uv_current);
		}
	}
	
	COLOR = color;
}
