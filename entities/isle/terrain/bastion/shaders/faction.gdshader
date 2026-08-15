shader_type canvas_item;

uniform sampler2D pattern : repeat_enable;
uniform vec4 pattern_color : source_color = vec4(1.0);
uniform float lighten_amount : hint_range(0.0, 1.0) = 0.4;

uniform float tiling = 33.0;
uniform vec2 speed = vec2(0.0, 0.0);
uniform float speed_factor = 0.5;
uniform float rotation : hint_range(-6.28318530717959, 6.28318530717959) = 0.0;

varying vec2 tiled_uv;

void vertex() {
    tiled_uv = VERTEX / tiling + TIME * speed * speed_factor;

    float c = cos(rotation);
    float s = sin(rotation);
    tiled_uv = mat2(vec2(c, -s), vec2(s, c)) * tiled_uv;
}

void fragment() {
    vec4 tex = texture(pattern, tiled_uv);
    float mask = tex.a;

    vec3 lighter_color = mix(pattern_color.rgb, vec3(1.0), lighten_amount);

    COLOR.rgb = mix(lighter_color, pattern_color.rgb, mask);
    COLOR.a = pattern_color.a;
}