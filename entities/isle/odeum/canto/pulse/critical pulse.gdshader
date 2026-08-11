shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_frequency : hint_range(0.1, 20.0) = 2.0; // 8. 
uniform float wave_amplitude : hint_range(0.0, 1.0) = 1.0; //0.3
uniform float ring_width : hint_range(0.01, 0.5) = 0.2; //0.05
uniform float diamond_width : hint_range(0.1, 2.0) = 0.6; // Ширина ромба (1.0 = квадрат)
uniform bool is_critical = false; // Включить/выключить анимацию

void fragment() {
	if (is_critical) {
		 vec2 uv_centered = UV - vec2(0.5);
	    vec2 uv_scaled = uv_centered;
	    uv_scaled.x = uv_centered.x / diamond_width;
	    float diamond_dist = abs(uv_scaled.x) + abs(uv_scaled.y);
	    
	    float max_dist = 0.5;
	    float diamond_mask = step(diamond_dist, max_dist);
	    float normalized_dist = diamond_dist / max_dist;
	    
	    float time = TIME * wave_speed;
	    float rings = sin(normalized_dist * wave_frequency - time) * wave_amplitude + 0.5;
	    
	    float ring_pattern = smoothstep(0.5 - ring_width, 0.5 + ring_width, rings);
	    vec4 base_color = texture(TEXTURE, UV);
	    vec4 ring_color = base_color * ring_pattern;
	    
	    COLOR = mix(base_color, ring_color, diamond_mask);
    }
	else {
        COLOR = texture(TEXTURE, UV);
	}
}