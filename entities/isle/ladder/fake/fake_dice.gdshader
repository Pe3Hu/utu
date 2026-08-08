shader_type canvas_item;

// ----------------------------------------------------
// Cube Transform
// ----------------------------------------------------

// 3D rotation (degrees).
uniform vec3 rotation_deg = vec3(0.0, 0.0, 0.0);

// Moves the cube inside the quad (-0.5 to 0.5).
// The actual position in the scene is still controlled
// by the Node2D transform.
uniform vec2 position_offset = vec2(0.0, 0.0);

// Cube size relative to the quad.
uniform float cube_size : hint_range(0.05, 1.0) = 0.6;

// Camera distance.
// Higher values = weaker perspective.
// Lower values = stronger perspective.
uniform float perspective : hint_range(0.5, 10.0) = 3.0;

// ----------------------------------------------------
// Face Textures
// ----------------------------------------------------

uniform sampler2D tex_top    : source_color, filter_nearest;
uniform sampler2D tex_bottom : source_color, filter_nearest;
uniform sampler2D tex_front  : source_color, filter_nearest;
uniform sampler2D tex_back   : source_color, filter_nearest;
uniform sampler2D tex_left   : source_color, filter_nearest;
uniform sampler2D tex_right  : source_color, filter_nearest;

// ----------------------------------------------------
// Fake Lighting
// ----------------------------------------------------

uniform vec3 light_dir = vec3(0.4, 0.8, 0.5);

uniform float ambient : hint_range(0.0, 1.0) = 0.35;

uniform float shading_strength : hint_range(0.0, 1.0) = 0.65;

// ----------------------------------------------------
// Optional Outline
// ----------------------------------------------------

uniform bool draw_outline = true;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float outline_width : hint_range(0.0, 0.05) = 0.01;

mat3 rotate_x(float angle) {
	float s = sin(angle);
	float c = cos(angle);

	return mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, c, -s),
		vec3(0.0, s, c)
	);
}

mat3 rotate_y(float angle) {
	float s = sin(angle);
	float c = cos(angle);

	return mat3(
		vec3(c, 0.0, s),
		vec3(0.0, 1.0, 0.0),
		vec3(-s, 0.0, c)
	);
}

mat3 rotate_z(float angle) {
	float s = sin(angle);
	float c = cos(angle);

	return mat3(
		vec3(c, -s, 0.0),
		vec3(s, c, 0.0),
		vec3(0.0, 0.0, 1.0)
	);
}

// Ray-Box Intersection (Slab Method)
bool intersect_box(
	vec3 ray_origin,
	vec3 ray_direction,
	vec3 box_min,
	vec3 box_max,
	out float t_near
) {
	vec3 inv_dir = 1.0 / ray_direction;

	vec3 t0 = (box_min - ray_origin) * inv_dir;
	vec3 t1 = (box_max - ray_origin) * inv_dir;

	vec3 tmin = min(t0, t1);
	vec3 tmax = max(t0, t1);

	t_near = max(max(tmin.x, tmin.y), tmin.z);
	float t_far = min(min(tmax.x, tmax.y), tmax.z);

	return t_near <= t_far && t_far > 0.0;
}

void fragment() {

	vec2 uv = (UV - 0.5) - position_offset;
	uv /= cube_size;

	// Virtual camera looking toward -Z.
	// The cube rotates by rotating the ray into cube space.
	vec3 ray_origin = vec3(0.0, 0.0, perspective);

	vec3 ray_direction = normalize(vec3(
		uv,
		-perspective
	));

	mat3 rotation =
		rotate_y(radians(rotation_deg.y))
		* rotate_x(radians(rotation_deg.x))
		* rotate_z(radians(rotation_deg.z));

	// Rotation matrix inverse
	mat3 inverse_rotation = transpose(rotation);

	vec3 ro = inverse_rotation * ray_origin;
	vec3 rd = inverse_rotation * ray_direction;

	float t_near;

	bool hit = intersect_box(
		ro,
		rd,
		vec3(-0.5),
		vec3(0.5),
		t_near
	);

	if (!hit) {
		COLOR = vec4(0.0);
		discard;
	}

	vec3 hit_position = ro + rd * t_near;

	float epsilon = 0.001;

	vec3 normal;
	vec2 face_uv;
	vec4 tex_color;

	if (hit_position.x > 0.5 - epsilon) {

		normal = vec3(1.0, 0.0, 0.0);

		face_uv = vec2(
			-hit_position.z,
			hit_position.y
		) + 0.5;

		tex_color = texture(tex_right, face_uv);

	} else if (hit_position.x < -0.5 + epsilon) {

		normal = vec3(-1.0, 0.0, 0.0);

		face_uv = vec2(
			hit_position.z,
			hit_position.y
		) + 0.5;

		tex_color = texture(tex_left, face_uv);

	} else if (hit_position.y > 0.5 - epsilon) {

		normal = vec3(0.0, 1.0, 0.0);

		face_uv = vec2(
			hit_position.x,
			-hit_position.z
		) + 0.5;

		tex_color = texture(tex_top, face_uv);

	} else if (hit_position.y < -0.5 + epsilon) {

		normal = vec3(0.0, -1.0, 0.0);

		face_uv = vec2(
			hit_position.x,
			hit_position.z
		) + 0.5;

		tex_color = texture(tex_bottom, face_uv);

	} else if (hit_position.z > 0.5 - epsilon) {

		normal = vec3(0.0, 0.0, 1.0);

		face_uv = vec2(
			hit_position.x,
			hit_position.y
		) + 0.5;

		tex_color = texture(tex_front, face_uv);

	} else {

		normal = vec3(0.0, 0.0, -1.0);

		face_uv = vec2(
			-hit_position.x,
			hit_position.y
		) + 0.5;

		tex_color = texture(tex_back, face_uv);

	}

	// Fake Lambert lighting
	vec3 world_normal = rotation * normal;

	float ndotl = max(
		dot(world_normal, normalize(light_dir)),
		0.0
	);

	float light = ambient + ndotl * shading_strength;

	vec3 final_color = tex_color.rgb * light;

	// Optional outline
	if (draw_outline) {

		vec2 outline_uv =
			uv * (1.0 + outline_width * 4.0);

		vec3 outline_ray =
			normalize(
				inverse_rotation *
				vec3(outline_uv, -perspective)
			);

		float t_dummy;

		bool outline_hit =
			intersect_box(
				ro,
				outline_ray,
				vec3(-0.5),
				vec3(0.5),
				t_dummy
			);

		if (!outline_hit) {

			final_color = mix(
				final_color,
				outline_color.rgb,
				outline_color.a
			);

		}
	}

	COLOR = vec4(final_color, tex_color.a);
}