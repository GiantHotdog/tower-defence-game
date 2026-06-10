class_name OptionContainer
extends MarginContainer

var current_index: int = 0

@onready var option_button:OptionButton = $PanelContainer/MarginContainer/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_index = option_button.selected
	option_button.selected = 0
	
	await Engine.get_main_loop().process_frame
	visible = false


func set_value(value):
	current_index = value
	option_button.selected = current_index


func increment():
	if current_index < option_button.item_count:
		current_index += 1
		option_button.selected = current_index


func decrement():
	if current_index > 0:
		current_index -= 1
		option_button.selected = current_index


func get_value():
	return current_index


func get_option_button():
	return option_button


func get_highlight_panel() -> Panel:
	return $PanelContainer


func display_options():
	option_button.show_popup()


func hide_options():
	option_button.get_popup().hide()
	option_button.selected = current_index
