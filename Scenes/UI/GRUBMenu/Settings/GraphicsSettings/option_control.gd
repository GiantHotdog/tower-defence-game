class_name OptionContainer
extends MarginContainer


@onready var option_button:OptionButton = $PanelContainer/MarginContainer/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.selected = 0


func set_value(value):
	option_button.selected = value


func increment():
	if option_button.selected < option_button.item_count:
		option_button.selected += 1


func decrement():
	if option_button.selected > 0:
		option_button.selected -= 1


func get_value():
	return option_button.selected


func get_option_button():
	return option_button


func get_highlight_panel() -> Panel:
	return $PanelContainer
