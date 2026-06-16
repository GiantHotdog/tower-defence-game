class_name TerminalLog
extends Control


@onready var text_label:RichTextLabel = $TerminalLog/PanelContainer/VBoxContainer/RichTextLabel


func add_log(message:String) -> void:
	append_time_str()
	text_label.text += " > " + message + "\n"


func add_warning(message:String) -> void:
	append_time_str()
	text_label.text += " > [color=orange]WARNING:[/color] " + message + "\n"


func add_error(message:String) -> void:
	append_time_str()
	text_label.text += " > [color=red]ERROR:[/color] " + message + "\n"


func get_time_str() -> String:
	var dict = Time.get_datetime_dict_from_system()
	return "[color=green][lb]%d:%d:%d[rb][/color]" % [dict["hour"], dict["minute"], dict["second"]]


func append_time_str() -> void:
	text_label.text += get_time_str()
