extends Node2D


var outer_radius = 0:
	set(value):
		outer_radius = value
		queue_redraw()


func _draw() -> void:
	draw_arc(Vector2.ZERO, outer_radius, 0, TAU, 128, Color(5.0, 5.0, 0, 0.1), 10.0, true)
	
	draw_circle(Vector2.ZERO, 16, Color("05070b"))
