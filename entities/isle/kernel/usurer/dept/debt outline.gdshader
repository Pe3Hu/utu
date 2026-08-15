shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // color line
uniform float line_scale : hint_range(0, 20) = 1.2; // thickness of the line
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_scale;
	
	// Calculate outline
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
	
	// Get original texture color (but we'll make it transparent)
	vec4 color = texture(TEXTURE, UV);
	
	// Make original texture transparent, show only outline
	if (outline > 0.0) {
		COLOR = vec4(line_color.rgb, line_color.a * alpha);
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0); // Fully transparent
	}
}