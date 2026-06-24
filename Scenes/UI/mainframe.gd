extends PathFollow2D

@onready var panel:StyleBoxFlat = $Panel2.get_theme_stylebox("panel")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_ratio = 1.0


func _process(delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	panel.border_color.a = 1 + sin(time * 4.0) * 0.5
