shader_type canvas_item;

uniform vec2 grid_size = vec2(60.0, 40.0);
uniform float speed = 20.0;
uniform vec4 bg_color: source_color = vec4(0.02, 0.027, 0.043, 1.0);
uniform vec4 text_color:source_color = vec4(0.0, 0.4, 0.0, 1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	vec2 grid = floor(UV * grid_size);
	float time_step = floor(TIME * speed);
	float rand_val = random(grid + vec2(time_step, -time_step * 0.5));
	
	vec2 cell = fract(UV * grid_size);
	
	float mask = 0.0;
	
	if (rand_val > 0.5) {
		if (cell.x > 0.45 && cell.x < 0.55 && cell.y > 0.2 && cell.y < 0.8) {
			mask = 1.0;
		}
	} else {
		if (cell.x > 0.3 && cell.x < 0.7 && cell.y > 0.2 && cell.y < 0.8) {
			if (cell.x < 0.4 || cell.x > 0.6 || cell.y < 0.3 || cell.y > 0.7) {
				mask = 1.0;
			}
		}
	}
	vec4 final_text = text_color * mask;
    COLOR = mix(bg_color, text_color, mask);
}
