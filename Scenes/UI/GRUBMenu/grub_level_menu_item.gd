class_name GrubLevelMenuItem
extends HBoxContainer

@export var text:String
@export var is_locked:bool = true

# Called when the node enters the scene tree for the first time.
func get_label() -> Label:
	return $Label


func _ready() -> void:
	$Label.text = text
	$TextureRect.visible = is_locked
