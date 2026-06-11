class_name Credits
extends GRUB


func _input(event: InputEvent) -> void:
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	
	if event is InputEventMouseMotion:
		var node:Control = get_viewport().gui_get_hovered_control()
		if node is Label and node.name != "CreditLabel":
			var id = get_filtered_index(node, "Label")
			update_selection(id)
		else:
			update_selection(-1)


func get_visible_children_of_type(node:Node, type: Variant) -> Array:
	var matching_children: Array = []
	for child in node.get_children():
		if is_instance_of(child, type) and child.visible and child.name != "CreditLabel":
			matching_children.append(child)
	return matching_children
	
	
func on_menu_select_pressed():
	play_outro()
	await outro_finished
	switch_to_previous_scene()


func get_filtered_index(node: Control, valid_type: StringName) -> int:
	var parent = node.get_parent()
	if not parent:
		return -1
		
	var filtered_index = 0
	for sibling in parent.get_children():
		if sibling == node:
			return filtered_index
		if sibling.is_class(valid_type) and sibling.visible and sibling.name != "CreditLabel":
			filtered_index += 1
			
	return -1
