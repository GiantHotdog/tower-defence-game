class_name HealthBar
extends Label

@export var character_count:int = 10
@export var health_percent:float = 0:
	set(value):
		health_percent = clamp(value, 0, 1)
		#health_percent = value
		_update_label()
@export var color:Color = Color(0.0, 0.745, 0.0):
	set(value):
		color = value
		label_settings.font_color = value

var health_full_char:String = "█"
var health_empty_char:String = "░"

func set_progress(health_pc:float):
	health_percent = health_pc
	_update_label()


func _update_label():
	var health_full_char_count:int = ceil(health_percent * character_count)
	var output:String = ""
	for i in range(health_full_char_count):
		output += health_full_char
		
	for i in range(character_count - health_full_char_count):
		output += health_empty_char
		
	text = output
	label_settings.font_color = color


func _ready() -> void:
	set_progress(1)
	label_settings = label_settings.duplicate(true)
