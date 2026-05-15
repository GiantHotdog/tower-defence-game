class_name PathRevealer
extends PathFollow2D

## The speed that the follower follows the path at
@export var move_speed:float = 3000
## The time in seconds that the follower pauses for after reaching the end of the path
@export var pause_time_between_passes:float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.is_wave_running:
		visible = false 
		progress = 0.0
	else:
		progress += move_speed * delta
		if progress_ratio == 1.0:
			await get_tree().create_timer(pause_time_between_passes).timeout
			progress = 0.0
