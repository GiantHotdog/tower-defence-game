class_name Tutorial
extends BaseLevel

enum TutorialStage {PLACING, STARTING_WAVE, UPGRADING, FINISHED}

@export var placing_tutorial_pos:Vector2i
@export var dialogues:Array[String] = []
@export var close_dialogue_indexes:Array[int] = []
var current_dialogue:int = 0

@onready var place_tutorial_guide:Control = $PlaceTutorialGuide
@onready var dialogue_label = $DialogueBox/PanelContainer/Label

var current_tutorial_stage:TutorialStage = TutorialStage.PLACING
var highlight_box:StyleBoxFlat

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
	
	update_tutorial_stage(TutorialStage.PLACING)
	
	place_tutorial_guide.position = placing_tutorial_pos * 128
	
	load_current_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if current_tutorial_stage == TutorialStage.PLACING and towers_placed >= 1:
		update_tutorial_stage(TutorialStage.STARTING_WAVE)


func _unhandled_input(_event: InputEvent) -> void:
	if not Globals.is_level_complete:
		if Input.is_action_just_pressed("select_tower"):
			var local_click_pos: Vector2 = get_local_mouse_position()
			var clicked_cell: Vector2i = tower_map.local_to_map(tower_map.to_local(local_click_pos))
			var scene_node: Node = get_scene_node_at_cell(clicked_cell)
			if scene_node:
				if Globals.placing == 0 and Globals.is_inspector_enabled:
					tower_info.tower_selected.emit(scene_node, self)
			elif Input.is_action_just_pressed("place_tower") and not is_tower_info_open:
				var tower_name:String = BaseTower.TowerTypes.keys()[Globals.placing]
				var cost = BaseTower.TowerCosts[tower_name]
				
				var is_valid_position:bool = true
				if current_tutorial_stage == TutorialStage.PLACING and clicked_cell != placing_tutorial_pos:
					is_valid_position = false
				
				if Globals.currency - cost >= 0 and is_valid_position:
					Globals.currency -= cost
					# Since the enum of towers and the tileset of towers align, we can just pass the enum in directly
					tower_map.set_cell(clicked_cell, 0, Vector2i(0, 0), Globals.placing)
					if Globals.placing:
						towers_placed += 1
			elif current_tutorial_stage != TutorialStage.UPGRADING:
				tower_info.tower_deselected.emit()


func update_tutorial_stage(tutorial_stage:TutorialStage):
	current_tutorial_stage = tutorial_stage
	if current_tutorial_stage == TutorialStage.PLACING:
		Globals.is_start_wave_enabled = false
		Globals.is_inspector_enabled = false
		Globals.is_upgrades_enabled = false
		
		$UI/Build/PanelContainer.add_theme_stylebox_override("panel", highlight_box)
		place_tutorial_guide.add_theme_stylebox_override("panel", highlight_box)
		
	elif current_tutorial_stage == TutorialStage.STARTING_WAVE:
		Globals.is_start_wave_enabled = true
		Globals.is_inspector_enabled = false
		Globals.is_upgrades_enabled = false
		
		$UI/TowerPlaceMenu.cancel_place()
		$UI/TowerPlaceMenu.close()
		
		$UI/Build/PanelContainer.remove_theme_stylebox_override("panel")
		place_tutorial_guide.remove_theme_stylebox_override("panel")
		place_tutorial_guide.visible = false
		$UI/StartWave/PanelContainer.add_theme_stylebox_override("panel", highlight_box)
		
		open_dialogue()
	
	elif current_tutorial_stage == TutorialStage.UPGRADING:
		Globals.is_start_wave_enabled = false
		Globals.is_inspector_enabled = true
		Globals.is_upgrades_enabled = true
		
		$UI/StartWave/PanelContainer.remove_theme_stylebox_override("panel")
		place_tutorial_guide.add_theme_stylebox_override("panel", highlight_box)
		place_tutorial_guide.visible = true
		
		open_dialogue()
	elif current_tutorial_stage == TutorialStage.FINISHED:
		Globals.reset_selective_disable_variables()
		place_tutorial_guide.visible = false


func load_current_dialogue():
	$DialogueBox/PanelContainer/Label.text = dialogues[current_dialogue]


func _on_next_dialogue_pressed() -> void:
	current_dialogue += 1
	if current_dialogue in close_dialogue_indexes:
		$DialogueBox.visible = false
		$DialogueBox/PanelContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		load_current_dialogue()


func close_dialogue():
	$DialogueBox.visible = false
	$DialogueBox/PanelContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	

func open_dialogue():
	$DialogueBox.visible = true
	$DialogueBox/PanelContainer.mouse_filter = Control.MOUSE_FILTER_STOP
	load_current_dialogue()


func _on_wave_complete(wave_number:int):
	if wave_number == 1:
		update_tutorial_stage(TutorialStage.UPGRADING)


func _on_inspect_window_opened(_unused, _unused2):
	if current_tutorial_stage == TutorialStage.UPGRADING:
		open_dialogue()
		place_tutorial_guide.remove_theme_stylebox_override("panel")
		place_tutorial_guide.visible = true
		$UI/TowerInfoDisplay/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/UpgradePaths.get_child(0).add_theme_stylebox_override("panel", highlight_box)
	


func _on_tower_info_display_tower_upgraded() -> void:
	if current_tutorial_stage == TutorialStage.UPGRADING:
		open_dialogue()
		$UI/TowerInfoDisplay/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/UpgradePaths.get_child(0).remove_theme_stylebox_override("panel")
		update_tutorial_stage(TutorialStage.FINISHED)
