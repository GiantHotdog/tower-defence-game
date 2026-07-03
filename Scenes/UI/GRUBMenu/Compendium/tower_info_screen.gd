class_name CompendiumTowerInfoScreen
extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	visible = false


func set_tower_name(value:String):
	%TowerNameLabel.text = value
	var regex = RegEx.create_from_string("\\[.*?\\]")
	%DescriptionTitle.text = "> man antivirus-db/" + regex.sub(value, "", true).to_kebab_case() + ".info"


func set_description(value:String):
	%DescriptionLabel.text = value


func set_image(image:Texture2D, image_modulate:Color):
	%TextureRect.texture = image
	%TextureRect.modulate = image_modulate


func set_attack_speed(value:float):
	%AttackSpeedLabel.text = "[%.2f" % value + " attacks per second]"
	%AttackSpeedBar.set_progress(value / 2.0)


func set_damage(value:float):
	%DamageLabel.text = "[%.2f" % value + " integrity removed per attack]"
	%DamageBar.set_progress(value / 2.0)


func set_range(value:float):
	%RangeLabel.text = "[%.2f" % value + "px range]"
	%RangeBar.set_progress(value / 1500)


func set_cost(value:float):
	%CostLabel.text = "[%.2f" % value + " Megabytes size]"
	%CostBar.set_progress(value / 50)
