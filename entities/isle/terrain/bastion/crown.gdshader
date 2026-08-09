shader_type canvas_item;

uniform int n = 5;                    
uniform int current_part = 0;         
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    vec2 uv_centered = UV - center;
	
	float angle_shift;
	
	if (n == 4){
		angle_shift = PI * 0.25;
	}
	if (n == 5){
		angle_shift = PI * 0.5;
	}
	
    float angle = atan(uv_centered.y, uv_centered.x) + angle_shift;
    angle = mod(angle, 2.0 * PI);

    int sector = int(angle / (2.0 * PI) * float(n));

    if (sector != current_part) {
        COLOR.a = 0.0;
    }
}