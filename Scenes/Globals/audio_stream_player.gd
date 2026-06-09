extends AudioStreamPlayer

var max_volume:int = 0
var min_volume:int = -30
var step_count:int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()


func get_volume():
	var step_size:float = float(max_volume - min_volume) / step_count
	return (volume_db - min_volume) / step_size

func set_volume(value:int):
	Globals.write_config("preferences.cfg", "AudioSettings", "master_audio", value)
	if value == 0:
		volume_db = -INF
	else:
		var step_size:float = float(max_volume - min_volume) / step_count
		volume_db = float(value * step_size) + min_volume
	
