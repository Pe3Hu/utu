shader_type canvas_item;

uniform sampler2D textures[5];
uniform bool indexs[5];

void fragment() {
	vec2 uv = UV;
	
	int col = int(floor(uv.x * 5.0));      
	
	vec2 cell_uv = vec2(
		fract(uv.x * 5.0),
		uv.y
	);
	
	if (indexs[col]) {
		COLOR = texture(textures[col], cell_uv);
	} else {
		COLOR = vec4(0.0);
	}
}
