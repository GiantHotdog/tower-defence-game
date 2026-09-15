extends ScrollContainer


signal upgrade_selected(button:UpgradeButton)


@export var start_centred_on:Control


var is_panning: bool = false
var touch_start_pos: Vector2 = Vector2.ZERO
var scroll_start_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	await get_tree().process_frame
	if start_centred_on:
		var target_pos: Vector2 = start_centred_on.position
		target_pos += (start_centred_on.size / 2.0)
		target_pos -= size / 2
		scroll_horizontal = int(target_pos.x)
		scroll_vertical = int(target_pos.y)
 # (448, 715)

func _gui_input(event: InputEvent) -> void:
	# Check for Right Mouse Button or Middle Mouse Button to drag the map
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_MIDDLE):
		if event.pressed:
			is_panning = true
			touch_start_pos = event.position
			scroll_start_pos = Vector2(scroll_horizontal, scroll_vertical)
		else:
			is_panning = false

	# Update the scroll offset as the mouse moves
	if event is InputEventMouseMotion and is_panning:
		var current_mouse_pos = event.position
		var drag_distance = current_mouse_pos - touch_start_pos
		
		# Subtract distance to push the map in the direction of the drag
		scroll_horizontal = int(scroll_start_pos.x - drag_distance.x)
		scroll_vertical = int(scroll_start_pos.y - drag_distance.y)
	
	# Consume scrolling events
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#$Upgrades.scale += Vector2(0.1, 0.1)
			accept_event()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#$Upgrades.scale -= Vector2(0.1, 0.1)
			accept_event()


func get_upgrades() -> Array[UpgradeButton]:
	var upgrades:Array = $Upgrades.get_children()
	var typed:Array[UpgradeButton] = []
	for child in upgrades:
		if child is UpgradeButton:
			typed.append(child)
	return typed


func _on_upgrade_selected(button: UpgradeButton) -> void:
	upgrade_selected.emit(button)
