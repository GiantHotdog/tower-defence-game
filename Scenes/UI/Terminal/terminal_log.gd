class_name TerminalLog
extends Control


@onready var text_label:RichTextLabel = $TerminalLog/PanelContainer/VBoxContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_log(message:String) -> void:
	text_label.text += "> " + message + "\n"


func add_warning(message:String) -> void:
	text_label.text += "> [color=orange]WARNING:[/color] " + message + "\n"


func add_error(message:String) -> void:
	text_label.text += "> [color=red]ERROR:[/color] " + message + "\n"
