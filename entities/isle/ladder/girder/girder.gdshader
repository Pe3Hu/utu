shader_type canvas_item;

uniform float frequency = 2.0;
uniform float speed = 6.0;
uniform float direction: hint_range(-1.0, 1.0) = -1.0;

uniform vec4 color_even: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color_odd: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float opacity: hint_range(0.0, 1.0) = 1.0;

void fragment() {
    float t = sin(UV.x * frequency + TIME * speed * direction);
    vec4 final_color = t > 0.0 ? color_even : color_odd;
    final_color.a *= opacity;
    COLOR = final_color;
}
