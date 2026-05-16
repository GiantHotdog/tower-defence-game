extends CanvasLayer

signal wave_started(number:int)

@onready var start_wave_container:Container = $StartWave
@onready var level_complete:Control = $LevelComplete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	start_wave_container.visible = not (Globals.is_wave_running or Globals.is_level_complete)
	level_complete.visible = Globals.is_level_complete


func _on_button_pressed() -> void:
	Globals.current_wave_number += 1
	Globals.is_wave_running = true
	wave_started.emit(Globals.current_wave_number)
