extends CanvasLayer

@onready var label:Label = $MarginContainer/Label
@onready var line_cooldown_timer:Timer = $LineCooldown

var type_speed:float = 100.0
var line_end_wait:float = 0.5
var start_time:int = 0

var current_type_pos:int = -1
var current_line:int = 0
var is_on_line_cooldown:bool = false

@export var text:Array[String] = ["Initialising Kernel...", "Loading user profile...", "Loading UI... ", "...", "...", "Complete!"]


func _ready() -> void:
	$TypeTimer.wait_time = 1 / type_speed
	line_cooldown_timer.wait_time = line_end_wait


func _on_type_timer_timeout() -> void:
	current_type_pos += 1
	if current_type_pos < text[current_line].length():
		if not is_on_line_cooldown:
			label.text += text[current_line][current_type_pos]
			label.text = label.text.replace("_", "")
	elif not line_cooldown_timer.time_left:
		is_on_line_cooldown = true
		line_cooldown_timer.start()



func _on_line_cooldown_timeout() -> void:
	if current_line < text.size() -1:
		label.text = label.text + "\n"
		is_on_line_cooldown = false
		current_line += 1
		current_type_pos = -1


func _on_blink_timer_timeout() -> void:
	var index = label.text.length() - 1
	if index >= 0:
		var last_char = label.text[index]
		if last_char == "_":
			label.text = label.text.substr(0, label.text.length() - 1)
		else:
			label.text = label.text + "_"
	else:
		label.text = "_"
	 
