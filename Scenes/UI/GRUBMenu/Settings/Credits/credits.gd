class_name Credits
extends GRUB

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
