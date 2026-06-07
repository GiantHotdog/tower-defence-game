extends AudioStreamPlayer

var max_volume:int = 0
var min_volume:int = -30
var step_count:int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_volume(value:int):
	if value == 0:
		volume_db = -INF
	else:
		var step_size:float = float(max_volume - min_volume) / step_count
		volume_db = float(value * step_size) + min_volume
	
