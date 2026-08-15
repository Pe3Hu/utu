shader_type canvas_item;

uniform vec4 color_1 : source_color = vec4(0.2, 0.6, 0.8, 0.5);
uniform vec4 color_2 : source_color = vec4(0.1, 0.5, 0.7, 0.4);
uniform float percentage : hint_range(0.0, 1.0) = 0;
uniform float wave_frequency_1 : hint_range(1.0, 50.0) = 1.0;
uniform float wave_amplitude_1 : hint_range(0.0, 0.5) = 0.04;
uniform float wave_frequency_2 : hint_range(1.0, 50.0) = 1.0;
uniform float wave_amplitude_2 : hint_range(0.0, 0.5) = 0.025;
uniform float wave_phase_offset : hint_range(0.0, 6.28318) = 0.0;

float calculate_wave_offset(float frequency, float amplitude, float time_multiplier, vec2 uv) {
    return sin(uv.x * frequency + TIME * time_multiplier + wave_phase_offset) * amplitude;
}

vec4 blend_water_color(vec4 base_color, vec4 water_color, float mask) {
    return mix(base_color, water_color, water_color.a * mask);
}

float smoothstep_edge(float edge0, float edge1, float x) {
    return smoothstep(edge0, edge1, x);
}

void fragment() {
    vec2 uv = UV;
    float mask = texture(TEXTURE, uv).a;

    float wave_offset_1 = calculate_wave_offset(wave_frequency_1, wave_amplitude_1, 2.0, uv);
    float wave_offset_2 = calculate_wave_offset(wave_frequency_2, wave_amplitude_2, 3.0, uv);

    float water_level_1 = 1.0 - percentage + wave_offset_1;
    float water_level_2 = 1.0 - percentage + wave_offset_2;

    float wave_mask_1 = smoothstep(water_level_1, water_level_1 + 0.01, uv.y);
    float wave_mask_2 = smoothstep(water_level_2, water_level_2 + 0.01, uv.y);

    vec4 final_color = vec4(0.0);

    if (wave_mask_1 > 0.0 && mask > 0.0) {
        final_color = blend_water_color(final_color, color_1, mask * wave_mask_1);
    }

    if (wave_mask_2 > 0.0 && mask > 0.0) {
        final_color = blend_water_color(final_color, color_2, mask * wave_mask_2);
    }

    COLOR = final_color;
}