class_name TowerInfo
extends Control

signal tower_selected(tower:BaseTower)
signal tower_deselected()

@onready var targeting_mode_button:OptionButton = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/TargetingMode
@onready var name_label:Label = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/Name

var current_tower:BaseTower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for option in BaseTower.TargetMode.keys():
		var clean:String = option.replace("_", " ").capitalize()
		targeting_mode_button.add_item(clean, BaseTower.TargetMode[option])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if current_tower:
		name_label.text = current_tower.display_name
		targeting_mode_button.selected = current_tower.target_mode


func _on_tower_selected(tower: BaseTower) -> void:
	current_tower = tower
	visible = true


func _on_tower_deselected() -> void:
	current_tower = null
	visible = false


func _on_targeting_mode_item_selected(index: int) -> void:
	if current_tower:
		current_tower.target_mode = index
		print("Set ", current_tower, "'s targeting mode to ", current_tower.TargetMode.keys()[index])
		


func _on_close_button_pressed() -> void:
	tower_deselected.emit()
