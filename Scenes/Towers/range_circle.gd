class_name RangeCircle
extends Node2D

var attack_range:float = 1:
	set(value):
		attack_range = value
		queue_redraw()

func _draw() -> void:
	var point_count = 64
	
	var line_color:Color = Color.WHITE
	var line_thickness:float = 1.0
	
	draw_arc(Vector2.ZERO, attack_range, 0, TAU, point_count, line_color, line_thickness, true)
