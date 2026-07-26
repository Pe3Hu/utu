shader_type canvas_item;

uniform sampler2D textures[6];
uniform int current_index = -1;

void fragment() {
	vec2 uv = UV;
	
	int col = int(floor(uv.x * 2.0));      
	int row = int(floor(uv.y * 3.0));      
	
	vec2 cell_uv = vec2(
		fract(uv.x * 2.0),
		fract(uv.y * 3.0)
	);
	
	int tex_index = row + col * 3;
	
	if (current_index >= 0 && current_index <= 5) {
		COLOR = (tex_index == current_index) ? 
			texture(textures[tex_index], cell_uv) : 
			vec4(0.0);
	} else {
		COLOR = texture(textures[tex_index], cell_uv);
	}
}
