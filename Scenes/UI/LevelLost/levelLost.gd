extends Control

signal outro_finished

var message:String = "CPUS: {coreCount}
DATE: {weekday} {month} {date} {time} {timezone} {year}
MACHINE: x86_64
MEMORY: {totalMemory}GB
PANIC: \"Kernel panic - not syncing: Fatal Machine Check\"
PID: {pid}

Press enter to reboot> █
"

var weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
var months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

func refresh_message():
	var unix_time = Time.get_unix_time_from_system()
	var date:Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	var time_zone = Time.get_time_zone_from_system()
	
	var time = "%02d:%02d:%02d" % [date["hour"], date["minute"], date["second"]]
	
	$MarginContainer/Label.text = message.format({"coreCount":OS.get_processor_count(),
		"weekday":weekdays[date["weekday"]],
		"month":months[date["month"]],
		"date":date["day"],
		"time":time,
		"timezone":time_zone.name,
		"year":date["year"],
		"totalMemory":(OS.get_memory_info()["physical"] / 1024 / 1024 / 1024) + 1,
		"pid":randi_range(1, 8192)
		})

func _ready() -> void:
	refresh_message()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			play_outro()
			await outro_finished
			if not is_inside_tree():
				return
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")

func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()
