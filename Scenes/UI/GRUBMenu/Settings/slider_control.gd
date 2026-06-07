class_name SliderContainer
extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_value(value):
	$HSlider.value = value

func increment():
	if $HSlider.value < $HSlider.max_value:
		$HSlider.value += 1


func decrement():
	if $HSlider.value > $HSlider.min_value:
		$HSlider.value -= 1


func get_value():
	return $HSlider.value
