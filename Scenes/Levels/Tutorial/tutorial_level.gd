class_name Tutorial
extends BaseLevel

enum TutorialStage {PLACING, STARTING_WAVE, UPGRADING}

var current_tutorial_stage:TutorialStage = TutorialStage.PLACING
var highlight_box:StyleBoxFlat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	update_tutorial_stage(TutorialStage.PLACING)
	highlight_box = StyleBoxFlat.new()
	highlight_box.draw_center = false
	highlight_box.set_border_width_all(3)
	highlight_box.border_color = Color(1, 1, 1)
	highlight_box.set_corner_radius_all(3)
	var tween = get_tree().create_tween()
	tween.tween_property(highlight_box, "border_color", Color(0, 0, 0), 1.5)
	tween.tween_property(highlight_box, "border_color", Color(1, 1, 1), 1.5)
	tween.set_loops()
	$UI/Build/PanelContainer.add_theme_stylebox_override("panel", highlight_box)


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
				if Globals.currency - cost >= 0:
					Globals.currency -= cost
					# Since the enum of towers and the tileset of towers align, we can just pass the enum in directly
					tower_map.set_cell(clicked_cell, 0, Vector2i(0, 0), Globals.placing)
					if Globals.placing:
						towers_placed += 1
			else:
				tower_info.tower_deselected.emit()

func update_tutorial_stage(tutorial_stage:TutorialStage):
	current_tutorial_stage = tutorial_stage
	if current_tutorial_stage == TutorialStage.PLACING:
		Globals.is_start_wave_enabled = false
		Globals.is_inspector_enabled = false
		Globals.is_upgrades_enabled = false
		
		$UI/Build/PanelContainer.add_theme_stylebox_override("panel", highlight_box)
	elif current_tutorial_stage == TutorialStage.STARTING_WAVE:
		Globals.is_start_wave_enabled = true
		Globals.is_inspector_enabled = false
		Globals.is_upgrades_enabled = false
		
		$UI/Build/PanelContainer.remove_theme_stylebox_override("panel")
		$UI/StartWave/PanelContainer.add_theme_stylebox_override("panel", highlight_box)
