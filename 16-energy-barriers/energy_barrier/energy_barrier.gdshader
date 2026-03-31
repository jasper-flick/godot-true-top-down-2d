shader_type canvas_item;
render_mode blend_add, unshaded;

uniform float segment_count = 1.0;

uniform vec4 pulse_offsets = vec4(0.0);
uniform vec4 pulse_speeds = vec4(2.0, 6.0, -4.0, -8.0);
uniform vec4 wave_wiggles_speeds = vec4(2.5, 4.0, 10.0, -8.0);

float wave(float wiggle, float speed, float energy, vec2 uv) {
	return smoothstep(energy, 0.0, abs(
			uv.y * 2.0 - 1.0 + sin(uv.x * wiggle - TIME * speed) * 0.25
	));
}

vec2 waves(float energy, vec2 uv) {
	return vec2(
			wave(
					wave_wiggles_speeds.x, wave_wiggles_speeds.z, energy, uv
			),
			wave(
					wave_wiggles_speeds.y, wave_wiggles_speeds.w, energy, uv
			)
	);
}

float pulse(float speed, float offset, float u) {
	return abs(mod(TIME * speed + offset, segment_count + 2.0) - u - 1.0);
}

float energy(float u) {
	float pulse_x = pulse(2.0, pulse_offsets.x, u);
	float pulse_y = pulse(6.0, pulse_offsets.y, u);
	float pulse_z = pulse(-4.0, pulse_offsets.z, u);
	float pulse_w = pulse(-8.0, pulse_offsets.w, u);
	float merged_pulses = min(min(pulse_x, pulse_y), min(pulse_z, pulse_w));
	
	float energy = smoothstep(1.0, 0.0, merged_pulses);
	energy = energy * 0.5 + 0.5;

	float edge_fade = min(u, 1.0) * min(segment_count - u, 1.0);
	return energy * edge_fade;
}

void fragment() {
	float energy = energy(UV.x);
	vec2 waves = waves(energy, UV);
	COLOR.rgb = vec3(waves.x, (waves.x + waves.y) * 0.5, waves.y);
	COLOR.rgb = COLOR.rgb * 0.9 + 0.1;
	COLOR.a = energy;
}
