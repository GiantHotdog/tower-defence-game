extends Control


@onready var title_container:Control = $Title
@onready var level_select_container:Control = $SelectLevel
@onready var levels_grid_container:Control = $SelectLevel/VBoxContainer/Levels
@onready var level_select_item_scene:PackedScene = load("res://Scenes/UI/Menu/level_select_item.tscn")

@export_file("*.tscn") var levels:Array[String] = []
@export var level_icons:Array[Texture2D] = []
@export var level_names:Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(levels.size()):
		var level_select_item:LevelSelectItem = level_select_item_scene.instantiate()
		level_select_item.scene_path = levels[i]
		if i < level_icons.size():
			var icon:Texture2D = level_icons.get(i)
			level_select_item.texture = icon
		if i < level_names.size():
			var level_name:String = level_names.get(i)
			level_select_item.level_name = level_name
		levels_grid_container.add_child(level_select_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	title_container.visible = false
	level_select_container.visible = true
