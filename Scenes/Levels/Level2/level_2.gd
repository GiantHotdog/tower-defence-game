extends BaseLevel


@export var tutorial_boxes:Array[TutorialBox] = []


func _on_tutorial_box_start_tutorial() -> void:
	pass # Replace with function body.


func _on_tutorial_box_skip_tutorial() -> void:
	%UI.show_compendium()
