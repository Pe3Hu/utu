shader_type canvas_item;

uniform bool parts[3];  
uniform vec2 center = vec2(0.5, 0.5); 

void fragment() {
    vec2 uv_centered = UV - center;
    
    float angle = atan(uv_centered.y, uv_centered.x);
    
    angle = mod(angle + PI, 2.0 * PI);
    
    angle += PI / 3.0;
    angle = mod(angle, 2.0 * PI);
    
    int sector = int(angle / PI * 1.5);
    
    bool should_draw = (sector == 0 && parts[0]) ||
                       (sector == 1 && parts[1]) ||
                       (sector == 2 && parts[2]);
    
    if (!should_draw) {
        COLOR.a = 0.0;
    }
}
