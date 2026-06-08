extends GRUB


func on_menu_select_pressed():
	match currently_selected:
		#0:
			#play_outro()
			#await outro_finished
			#get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")
		1:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Settings/AudioSettings/audio_settings.tscn")
		#2:
			#play_outro()
			#await outro_finished
			#get_tree().quit()
		3:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Settings/Credits/credits.tscn")
		4:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")
