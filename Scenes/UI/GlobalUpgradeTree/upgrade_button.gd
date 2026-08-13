extends Control
class_name UpgradeButton

signal upgrade_unlocked(upgrade:GlobalUpgrade, current_level:int)
signal upgrade_selected(button:UpgradeButton)

@export var upgrade_data:GlobalUpgrade
@export var prerequisites:Array[UpgradeButton]

var selected:bool = false
var selected_theme:StyleBoxFlat
var deselected_theme:StyleBoxFlat


func can_unlock() -> bool:
	return upgrade_data.can_unlock()


func is_unlocked():
	return upgrade_data.is_unlocked()

func _ready() -> void:
	selected_theme = StyleBoxFlat.new()
	selected_theme.draw_center = false
	selected_theme.border_color = Color.WHITE
	selected_theme.set_border_width_all(3)
	selected_theme.set_corner_radius_all(3)
	
	deselected_theme = StyleBoxFlat.new()
	deselected_theme.draw_center = false
	deselected_theme.border_color = Color(0, 0, 0, 0)
	deselected_theme.set_border_width_all(3)
	
	upgrade_data.current_level = Globals.get_global_upgrade_tier(upgrade_data.id)
	
	await get_tree().process_frame
	update()


func is_any_prerequisite_unlocked():
	for prerequisite in prerequisites:
		if prerequisite.is_unlocked():
			return true
	# Falls back to true if no prerequisites exist
	return prerequisites.size() == 0


func update_ui() -> void:
	if upgrade_data:
		tooltip_text = upgrade_data.description
		%UpgradeButton.tooltip_text = upgrade_data.description
		%LevelLabel.text = str(upgrade_data.current_level) + "/" + str(upgrade_data.max_level)
		
		if upgrade_data.is_unlocked():
			%UpgradeButton.modulate = Color(1, 1, 1)
		elif can_unlock():
			%UpgradeButton.modulate = Color(0.5, 0.5, 0.5)
		else:
			%UpgradeButton.modulate = Color(0.3, 0.3, 0.3)
		
		visible = is_any_prerequisite_unlocked()


func _on_upgrade_button_pressed() -> void:
	#if can_unlock():
		#upgrade_data.unlock()
		#
		#update_ui()
		#upgrade_unlocked.emit(upgrade_data, upgrade_data.current_level)
	upgrade_selected.emit(self)
	update_ui()


func get_button_center() -> Vector2:
	return %UpgradeButton.global_position + %UpgradeButton.size / 2


func get_cost() -> int:
	return upgrade_data.cost


func get_level() -> int:
	return upgrade_data.current_level


## Draws in the lines that connect this button to its prerequisite buttons. 
## Should only be called when required due to the overhead of removing and instantiating nodes
func draw_connection_lines():
	# Remove all the old lines
	for child in %Lines.get_children():
		child.queue_free()
	
	#var screen_dimensions = get_window().size
	for prerequisite:UpgradeButton in prerequisites:
		var line:Line2D = Line2D.new()
		%Lines.add_child(line)
		
		line.default_color = Color(0.5, 0.5, 0.5)
		line.width = 5
		line.z_index = -1
		
		line.add_point(line.to_local(get_button_center()))
		line.add_point(line.to_local(prerequisite.get_button_center()))


func update():
	update_ui()
	draw_connection_lines()
