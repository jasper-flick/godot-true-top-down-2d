shader_type canvas_item;

uniform float speed = 1.0;

varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x - TIME * speed, UV.y));
	COLOR *= vertex_color;
}
