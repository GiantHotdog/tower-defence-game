class_name SliderContainer
extends MarginContainer


@onready var slider:HSlider = $PanelContainer/MarginContainer/HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_value(value):
	slider.value = value


func increment():
	if slider.value < slider.max_value:
		slider.value += 1


func decrement():
	if slider.value > slider.min_value:
		slider.value -= 1


func get_value():
	return slider.value


func get_slider():
	return slider


func get_highlight_panel() -> Panel:
	return $PanelContainer
