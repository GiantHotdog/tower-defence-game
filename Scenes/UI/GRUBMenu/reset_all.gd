extends Control

signal outro_finished

@export_file("*.tscn") var back_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Title.text = "
KERNEL MENU        version {version}".format({"version":Globals.version})


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_back"):
		switch_to_previous_scene()

func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()


func switch_to_previous_scene():
	if back_level:
		play_outro()
		await outro_finished
		if is_inside_tree():
			get_tree().change_scene_to_file(back_level)


func _on_button_pressed() -> void:
	Globals.reset_all_progress_to_default()
	play_outro()
	await outro_finished
	switch_to_previous_scene()


func _on_button_2_pressed() -> void:
	play_outro()
	await outro_finished
	switch_to_previous_scene()
