class_name Tutorial
extends BaseLevel

enum TutorialStage {PLACING, STARTING_WAVE, UPGRADING, FINISHED}

@export var placing_tutorial_pos:Vector2i
@export var dialog_boxes:Array[TutorialBox] = []
var current_dialogue:int = 0

@onready var place_tutorial_guide:Control = $PlaceTutorialGuide
@onready var start_tutorial_box = $StartTutorialBox

var current_tutorial_stage:TutorialStage = TutorialStage.PLACING
var highlight_box:StyleBoxFlat

var tutorial_skipped:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	highlight_box = StyleBoxFlat.new()
	highlight_box.draw_center = false
	highlight_box.set_border_width_all(3)
	highlight_box.border_color = Color(1, 1, 1)
	highlight_box.set_corner_radius_all(3)
	
	var tween = get_tree().create_tween()
	tween.tween_property(highlight_box, "border_color", Color(0, 0, 0), 1.5)
	tween.tween_property(highlight_box, "border_color", Color(1, 1, 1), 1.5)
	tween.set_loops()
	
	#update_tutorial_stage(TutorialStage.PLACING)
	
	place_tutorial_guide.position = placing_tutorial_pos * 128


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if current_tutorial_stage == TutorialStage.PLACING and towers_placed >= 1:
		var next:TutorialBox = dialog_boxes.get(2)
		if next:
			next.visible = true
		current_dialogue = 2


func can_place_tower(tower_pos:Vector2i, _write_to_log:bool = false) -> bool:
	if current_tutorial_stage == TutorialStage.PLACING and tower_pos != placing_tutorial_pos:
		return false
	return super.can_place_tower(tower_pos)


func update_tutorial_stage(tutorial_stage:TutorialStage):
	current_tutorial_stage = tutorial_stage
	if current_tutorial_stage == TutorialStage.PLACING:
		#Globals.is_start_wave_enabled = false
		#Globals.is_inspector_enabled = false
		#Globals.is_upgrades_enabled = false
		
		$UI/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/Build/PanelContainer.add_theme_stylebox_override("panel", highlight_box)
		place_tutorial_guide.add_theme_stylebox_override("panel", highlight_box)
		
	elif current_tutorial_stage == TutorialStage.STARTING_WAVE:
		#Globals.is_start_wave_enabled = true
		#Globals.is_inspector_enabled = false
		#Globals.is_upgrades_enabled = false
		
		$UI/TowerPlaceMenu.cancel_place()
		$UI/TowerPlaceMenu.close()
		
		$UI/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/Build/PanelContainer.remove_theme_stylebox_override("panel")
		place_tutorial_guide.remove_theme_stylebox_override("panel")
		place_tutorial_guide.visible = false
		$UI/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/StartWave/PanelContainer.add_theme_stylebox_override("panel", highlight_box)
	
	elif current_tutorial_stage == TutorialStage.UPGRADING:
		#Globals.is_start_wave_enabled = false
		#Globals.is_inspector_enabled = true
		#Globals.is_upgrades_enabled = true
		
		$UI/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/StartWave/PanelContainer.remove_theme_stylebox_override("panel")
		place_tutorial_guide.add_theme_stylebox_override("panel", highlight_box)
		place_tutorial_guide.visible = true
	elif current_tutorial_stage == TutorialStage.FINISHED:
		Globals.reset_selective_disable_variables()
		place_tutorial_guide.visible = false
		$UI/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/Build/PanelContainer.remove_theme_stylebox_override("panel")


func _on_wave_complete(wave_number:int):
	if wave_number == 1:
		var next:TutorialBox = dialog_boxes.get(3)
		if next:
			next.visible = true
		current_dialogue = 3


func _on_inspect_window_opened(_unused, _unused2):
	if current_tutorial_stage == TutorialStage.UPGRADING:
		place_tutorial_guide.remove_theme_stylebox_override("panel")
		place_tutorial_guide.visible = true
		$UI/TowerInfoDisplay/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/UpgradePaths.get_child(0).add_theme_stylebox_override("panel", highlight_box)


func _on_tower_info_display_tower_upgraded() -> void:
	if current_tutorial_stage == TutorialStage.UPGRADING:
		$UI/TowerInfoDisplay/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/UpgradePaths.get_child(0).remove_theme_stylebox_override("panel")
		var next:TutorialBox = dialog_boxes.get(4)
		if next:
			next.visible = true
		current_dialogue = 4


func _on_start_tutorial_box_skip_tutorial() -> void:
	update_tutorial_stage(TutorialStage.FINISHED)
	tutorial_skipped = true


func _on_start_tutorial_box_start_tutorial() -> void:
	var next:TutorialBox = dialog_boxes.get(1)
	if next:
		next.visible = true
	current_dialogue = 1


func _on_start_tutorial_box_2_start_tutorial() -> void:
	update_tutorial_stage(TutorialStage.PLACING)


func _on_start_tutorial_box_3_start_tutorial() -> void:
	update_tutorial_stage(TutorialStage.STARTING_WAVE)


func _on_start_tutorial_box_4_start_tutorial() -> void:
	update_tutorial_stage(TutorialStage.UPGRADING)


func _on_start_tutorial_box_5_start_tutorial() -> void:
	update_tutorial_stage(TutorialStage.FINISHED)
