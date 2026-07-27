shader_type canvas_item;

uniform sampler2D textures[6];
uniform int current_index = -1;
uniform bool show_all = true;

void fragment() {
	vec2 uv = UV;
	
	int col = int(floor(uv.x * 2.0));      
	int row = int(floor(uv.y * 3.0));      
	
	vec2 cell_uv = vec2(
		fract(uv.x * 2.0),
		fract(uv.y * 3.0)
	);
	
	int tex_index = row + col * 3;
	
	if (show_all || tex_index == current_index) {
		COLOR = texture(textures[tex_index], cell_uv);
	} else {
		COLOR = vec4(0.0);
	}
}
