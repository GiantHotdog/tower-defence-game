class_name SliderContainer
extends MarginContainer

signal dragging_finished(node:SliderContainer)

var dragging:bool = false

@onready var slider:HSlider = $PanelContainer/MarginContainer/HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_value(value):
	slider.value = value


func increment():
	print("++")
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


func _on_h_slider_drag_started() -> void:
	dragging = true


func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	dragging_finished.emit(self)
	dragging = false
