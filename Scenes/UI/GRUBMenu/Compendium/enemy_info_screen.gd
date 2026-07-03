class_name EnemyInfoScreen
extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var unix_time = Time.get_unix_time_from_system()
	var date:Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	var dateString:String = "%02d/%02d" % [date["day"], date["month"]]
	%MalwareDBLabel.text = "OpenMalwareDB - {date}".format({"date":dateString})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	visible = false


func set_tower_name(value:String):
	%EnemyNameLabel.text = value
	var regex = RegEx.create_from_string("\\[.*?\\]")
	%DescriptionTitle.text = "> cat open-malware-db/" + regex.sub(value, "", true).to_kebab_case() + ".info"


func set_description(value:String):
	%DescriptionLabel.text = value


func set_image(image:Texture2D, image_modulate:Color):
	%TextureRect.texture = image
	%TextureRect.modulate = image_modulate


func set_move_speed(value:float):
	%MoveSpeedLabel.text = "[%.2f" % value + " px per second]"
	%MoveSpeedBar.set_progress(value / 750.0)


func set_damage(value:float):
	%DamageLabel.text = "[%.2f" % value + " damage to mainframe]"
	%DamageBar.set_progress(value / 100.0)


func set_health(value:float):
	%HealthLabel.text = "[%.2f" % value + " total integrity]"
	%HealthBar.set_progress(value / 10)


#func set_cost(value:float):
	#%CostLabel.text = "[%.2f" % value + " Megabytes size]"
	#%CostBar.set_progress(value / 50)
