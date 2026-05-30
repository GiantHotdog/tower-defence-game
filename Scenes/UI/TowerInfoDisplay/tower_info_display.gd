class_name TowerInfo
extends Control

signal tower_selected(tower:BaseTower, level:BaseLevel)
signal tower_deselected()

@onready var targeting_mode_button:OptionButton = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/TargetingMode
@onready var name_label:Label = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/Name
@onready var upgrade_paths_container:VBoxContainer = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/UpgradePaths

@onready var upgrade_path_scene:PackedScene = load("res://Scenes/UI/visual_upgrade_path.tscn")

var current_tower:BaseTower
var parent_level:BaseLevel = null

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


func _on_tower_selected(tower: BaseTower, level:BaseLevel) -> void:
	if current_tower:
		_on_tower_deselected()
	current_tower = tower
	
	var upgrade_paths_count:int = current_tower.upgrade_paths.size()
	for path in range(upgrade_paths_count):
		var scene:VisualUpgradePath = upgrade_path_scene.instantiate()
		scene.path_number = path + 1
		scene.upgrade_path = current_tower.upgrade_paths[path]
		scene.tower = current_tower
		upgrade_paths_container.add_child(scene)
	
	visible = true
	current_tower.set_range_circle_visible(true)
	parent_level = level
	level.is_tower_info_open = true


func _on_tower_deselected() -> void:
	for node in upgrade_paths_container.get_children():
		upgrade_paths_container.remove_child(node)
		node.queue_free()
		
	current_tower.set_range_circle_visible(false)
	current_tower = null
	visible = false
	parent_level.is_tower_info_open = false


func _on_targeting_mode_item_selected(index: int) -> void:
	if current_tower:
		current_tower.target_mode = index as BaseTower.TargetMode
		print("Set ", current_tower, "'s targeting mode to ", current_tower.TargetMode.keys()[index])
		


func _on_close_button_pressed() -> void:
	tower_deselected.emit()


func _on_delete_button_pressed() -> void:
	current_tower.destroy_self()
	_on_tower_deselected()
