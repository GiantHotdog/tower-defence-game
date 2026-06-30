extends CanvasLayer


signal show_compendium()


@onready var parent:UI = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and parent.can_pause and not $Compendium.visible:
		get_tree().paused = not get_tree().paused
		visible = not visible


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")


func _on_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_button_2_pressed() -> void:
	show_compendium.emit()
