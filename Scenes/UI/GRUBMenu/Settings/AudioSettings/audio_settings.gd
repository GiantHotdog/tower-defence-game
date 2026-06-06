extends GRUB


func on_menu_select_pressed():
	match currently_selected:
		0:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Settings/settings.tscn")
		1:
			play_outro()
			await outro_finished
		2:
			play_outro()
			await outro_finished
