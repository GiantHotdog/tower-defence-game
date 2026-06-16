extends PanelContainer

@onready var health_label:Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var health_bar:HealthBar = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HealthBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_label.text = str(Globals.health) + "%"
	health_bar.set_progress(Globals.health / 100.0)
