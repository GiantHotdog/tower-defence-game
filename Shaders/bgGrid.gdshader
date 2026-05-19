shader_type canvas_item;

// Exposed parameters (Now strictly pixel-based)
uniform vec2 grid_size = vec2(64.0, 64.0);
uniform vec4 grid_color : source_color = vec4(0.0, 0.5, 0.6, 0.3);
uniform float line_thickness : hint_range(0.5, 5.0) = 1.0;          // 1.0 = exactly 1 pixel thick

// Varying variables pass data cleanly from the Vertex step to the Fragment step
varying vec2 pixel_pos;

void vertex() {
    // VERTEX natively holds the exact pixel coordinates of the current point
    pixel_pos = VERTEX;
}

void fragment() {
    // Find the absolute distance to the closest pixel boundary
    vec2 distance_to_line = min(mod(pixel_pos, grid_size), grid_size - mod(pixel_pos, grid_size));
    
    // Check if the current pixel location falls within our line limits
    float on_line_x = step(distance_to_line.x, line_thickness * 0.5);
    float on_line_y = step(distance_to_line.y, line_thickness * 0.5);
    
    // Merge grid layouts
    float grid_mask = max(on_line_x, on_line_y);
    
    // Render final color blending
    COLOR = vec4(grid_color.rgb, grid_color.a * grid_mask);
}