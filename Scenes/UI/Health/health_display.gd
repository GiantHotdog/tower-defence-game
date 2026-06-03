extends PanelContainer

@onready var health_label:Label = $MarginContainer/HBoxContainer/HealthLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_label.text = str(Globals.health)
