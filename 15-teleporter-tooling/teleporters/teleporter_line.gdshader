shader_type canvas_item;
render_mode unshaded;

void fragment() {
    COLOR.a *= step(0.75, fract(UV.x * 0.25 - TIME * 0.5));
}
