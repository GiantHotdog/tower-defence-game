extends Control


signal outro_finished

var selected_button:UpgradeButton = null


func refresh_upgrade_textures():
	for upgrade:UpgradeButton in %Upgrades.get_upgrades():
		upgrade.update()


#func refresh_available_skill_points():
	#var unspent_skill_points = get_unspent_skill_points()
	#for upgrade:UpgradeButton in %Upgrades.get_upgrades():
		#upgrade.set_unspent_skill_points(unspent_skill_points)


func _on_upgrade_bought(upgrade:GlobalUpgrade, tier:int):
	refresh_upgrade_textures()
	refresh_labels()
	Globals.set_global_upgrade_tier(upgrade.id, tier)


func _ready() -> void:
	$FadeOutColorRect.custom_minimum_size = get_viewport_rect().size
	refresh_labels()
	await get_tree().process_frame
	refresh_upgrade_textures()
	$FadeOutColorRect.custom_minimum_size = Vector2(0, 0)


func refresh_labels() -> void:
	%SkillPointsLabel.text = "Skill points: " + str(get_unspent_skill_points())


func get_total_skill_points_spent() -> int:
	var total:int = 0
	for upgrade:UpgradeButton in %Upgrades.get_upgrades():
		if upgrade.is_unlocked():
			total += upgrade.get_cost() * upgrade.get_level()
	return total


func get_unspent_skill_points() -> int:
	return Globals.get_skill_points() - get_total_skill_points_spent()


func refresh_info_window(upgrade:GlobalUpgrade):
	%NameLabel.text = upgrade.name
	%CostLabel.text = "Cost: %d skill points" % upgrade.cost
	%DescriptionLabel.text = upgrade.description + " (Currently %.02f)" % Globals.get_current_modifier_for(upgrade.upgradeClass)


func hide_info_window():
	%InfoWindow.visible = false


func show_info_window():
	%InfoWindow.visible = true


func _on_upgrade_selected(button: UpgradeButton):
	if selected_button:
		selected_button.add_theme_stylebox_override("panel", button.deselected_theme)
		if selected_button == button:
			# Unlock if it was already selected
			unlock_button(selected_button)
			if selected_button.upgrade_data.is_below_max_level():
				selected_button.add_theme_stylebox_override("panel", button.selected_theme)
				refresh_info_window(button.upgrade_data)
			else:
				selected_button = null
				hide_info_window()
			return
	selected_button = button
	selected_button.add_theme_stylebox_override("panel", button.selected_theme)
	refresh_info_window(button.upgrade_data)
	show_info_window()
	refresh_upgrade_textures()
	refresh_labels()


func unlock_button(button:UpgradeButton):
	if button.upgrade_data.can_unlock() and get_unspent_skill_points() >= button.get_cost():
		button.upgrade_data.unlock()
		_on_upgrade_bought(button.upgrade_data, button.upgrade_data.current_level)


func _on_buy_upgrade_button_pressed() -> void:
	unlock_button(selected_button)


func _on_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if selected_button:
				selected_button.add_theme_stylebox_override("panel", selected_button.deselected_theme)
			selected_button = null
			hide_info_window()


func reset_all_upgrades():
	for upgrade_button:UpgradeButton in %Upgrades.get_upgrades():
		Globals.set_global_upgrade_tier(upgrade_button.upgrade_data.id, 0)
		upgrade_button.upgrade_data.current_level = 0
	
	if selected_button:
		selected_button.add_theme_stylebox_override("panel", selected_button.deselected_theme)
		selected_button = null
	hide_info_window()
	
	refresh_labels()
	refresh_upgrade_textures()


func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($FadeOutColorRect, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($FadeOutColorRect, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()


func _on_reset_button_pressed() -> void:
	%ResetConfirmationWindow.visible = true


func _on_cancel_reset_pressed() -> void:
	%ResetConfirmationWindow.visible = false


func _on_confirm_reset_pressed() -> void:
	%ResetConfirmationWindow.visible = false
	reset_all_upgrades()


func _on_main_menu_button_pressed() -> void:
	play_outro()
	await outro_finished
	get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")
