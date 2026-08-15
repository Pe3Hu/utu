shader_type canvas_item;

uniform float inverse_speed = 15.0;
uniform float intensity = 0.5;

void fragment() {
    vec2 fragCoord = FRAGCOORD.xy;
    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = (2.0 * fragCoord - res) / min(res.x, res.y);

    float t = TIME / inverse_speed;

    for (int i = 1; i < 50; i++) {
        float fi = float(i);

        uv.x += 0.6 / fi * cos(fi * 2.5 * uv.y + t);
        uv.y += 0.6 / fi * cos(fi * 1.5 * uv.x + t);
    }

    float col = intensity / abs(sin(t - uv.x - uv.y));

    COLOR = vec4(vec3(col), 1.0);
}