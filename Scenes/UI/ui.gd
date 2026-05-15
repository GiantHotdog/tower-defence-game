extends CanvasLayer

@onready var start_wave_container:Container = $StartWave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	start_wave_container.visible = not Globals.is_wave_running


func _on_button_pressed() -> void:
	Globals.is_wave_running = true
