extends Control

@onready var targeting_mode_button:OptionButton = $Panel/VBoxContainer/TargetingMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for option in BaseTower.TargetMode.keys():
		var clean:String = option.replace("_", " ").to_lower().capitalize()
		targeting_mode_button.add_item(clean, BaseTower.TargetMode[option])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
