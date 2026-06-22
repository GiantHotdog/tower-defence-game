class_name TutorialBox
extends CanvasLayer

signal start_tutorial()
signal skip_tutorial


func _on_skip_button_pressed() -> void:
	skip_tutorial.emit()
	visible = false


func _on_start_button_pressed() -> void:
	start_tutorial.emit()
	visible = false
