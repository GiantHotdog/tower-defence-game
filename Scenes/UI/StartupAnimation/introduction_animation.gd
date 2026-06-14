extends CanvasLayer

@onready var label:Label = $MarginContainer/Label
@onready var line_cooldown_timer:Timer = $LineCooldown

var type_speed:float = 60.0
var line_end_wait:float = 1
var start_time:int = 0

var current_type_pos:int = -1
var current_line:int = 0
var is_on_line_cooldown:bool = false
var is_finished:bool = false

@export var text:Array[String] = [
	"Kernel Panic ", 
	"A tower defence game ", 
	"Built using the Godot Game Engine ", 
	"Created for Hack Club Stardance ", 
	"By @teamlewiscrafty ", 
	"Loading... ",
	"Load complete! ", 
	"Press enter to load menu: "
]


func _ready() -> void:
	$TypeTimer.wait_time = 1 / type_speed
	line_cooldown_timer.wait_time = line_end_wait


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("intro_skip"):
		fade_out(change_to_menu)


func change_to_menu():
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")


func _on_type_timer_timeout() -> void:
	current_type_pos += 1
	if current_type_pos < text[current_line].length():
		if not is_on_line_cooldown:
			label.text += text[current_line][current_type_pos]
			label.text = label.text.replace("█", "")
	elif not line_cooldown_timer.time_left:
		is_on_line_cooldown = true
		line_cooldown_timer.start()



func _on_line_cooldown_timeout() -> void:
	if current_line < text.size() -1:
		label.text = label.text + "\n"
		is_on_line_cooldown = false
		current_line += 1
		current_type_pos = -1
	else:
		is_finished = true


func _on_blink_timer_timeout() -> void:
	var index = label.text.length() - 1
	if index >= 0:
		var last_char = label.text[index]
		if last_char == "█":
			label.text = label.text.substr(0, label.text.length() - 1)
		else:
			label.text = label.text + "█"
	else:
		label.text = "█"
	 

func fade_out(callback:Callable):
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($FadeOutRect, "color", Color(), .5)
	tween.tween_callback(callback)
