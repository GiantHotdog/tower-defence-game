extends "res://Scenes/UI/Health/health_display.gd"


var total_wave_count:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_wave_count = get_parent().get_parent().get_parent().get_parent().get_total_wave_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_wave_number = Globals.current_wave_number
	if Globals.is_wave_running:
		current_wave_number -= 1
	health_label.text = str(int(current_wave_number / float(total_wave_count) * 100)) + "%"
	health_bar.set_progress(int(current_wave_number / float(total_wave_count) * 100) / 100.0)
