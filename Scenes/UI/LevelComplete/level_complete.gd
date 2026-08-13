class_name LevelComplete
extends Control


signal breakdown_finished


@export var level_complete_xp:int = 50
@export var multiplier:float = Globals.calculate_xp_gain_multiplier()
@export var message_start_point:int = 21

var character_appear_delay:float = 20 #ms

var message_start_time = 0
var waiting = false

# Large number of spaces after each
var xp_breakdown_template:String = """Experience Breakdown:
	> Base XP gained: {baseGain} XP
	> XP multiplier: x{multiplier}
	> Total XP gained: {totalGain} XP"""


#func _ready() -> void:
	#_level_complete()


func _process(delta: float) -> void:
	if message_start_time > 0:
		if %ExperienceBreakdownLabel.visible_characters > %ExperienceBreakdownLabel.text.length():
			%ExperienceBreakdownLabel.visible_characters = -1
			#if %ExperienceBreakdownLabel.text[message_start_point + i] == "\n":
				#await get_tree().create_timer(0.2).timeout
		if %ExperienceBreakdownLabel.visible_characters == -1 and not waiting:
			finish_message()
		else:
			var time_since_start = Time.get_ticks_msec() - message_start_time
			var characters = time_since_start / character_appear_delay + message_start_point
			%ExperienceBreakdownLabel.visible_characters = characters


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/new_menu.tscn")


func _level_complete(level_xp_gain = level_complete_xp) -> void:
	multiplier = Globals.calculate_xp_gain_multiplier()
	# Game is now over
	var total_gain:int = int(level_xp_gain * multiplier)
	%ExperienceProgressBar.gain_xp(total_gain, 1.0, breakdown_finished)
	%ExperienceBreakdownLabel.text = xp_breakdown_template.format(
			{
				"	":"",
				"baseGain":level_xp_gain,
				"multiplier":multiplier,
				"totalGain":total_gain
			}
		)
	%ExperienceBreakdownLabel.visible_characters = message_start_point
	await get_tree().create_timer(0.5).timeout
	message_start_time = Time.get_ticks_msec()


func finish_message():
	message_start_time = 0
	waiting = true
	await get_tree().create_timer(0.5).timeout
	breakdown_finished.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("intro_skip") and visible:
		%ExperienceBreakdownLabel.visible_characters = -1
		finish_message()


func _on_next_char_timer_timeout() -> void:
	%ExperienceBreakdownLabel.visible_characters += -1


func _on_breakdown_finished() -> void:
	print("XP Breakdown finished")
