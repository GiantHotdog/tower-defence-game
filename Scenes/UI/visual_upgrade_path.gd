class_name VisualUpgradePath
extends Control


signal tower_upgraded

@export var upgrade_path:UpgradePath:
	set(value):
		upgrade_path = value
		update_labels()


@export var path_number:int = 0:
	set(value):
		path_number = value
		$VisualUpgradePath/Label.text = "Path " + str(value) + ":"

@onready var upgrade_button:Button = $VisualUpgradePath/UpgradeButton
@onready var description_label:Label = $VisualUpgradePath/DescriptionLabel

var tower:BaseTower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisualUpgradePath/Label.text = "Path " + str(path_number) + ":"
	if upgrade_path:
		var cost:int = upgrade_path.get_next_upgrade_cost()
		upgrade_button.text = "Cost: " + str(cost)
	update_description()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrade_button_pressed() -> void:
	if upgrade_path:
		var cost:int = upgrade_path.get_next_upgrade_cost()
		if cost <= Globals.currency:
			var upgrade:Upgrade = upgrade_path.get_next_upgrade()
			update_labels()
			tower_upgraded.emit()
			if upgrade:
				tower.add_upgrade(upgrade)
				Globals.currency -= cost
			
			cost = upgrade_path.get_next_upgrade_cost()
			if cost < 0:
				upgrade_button.text = "Fully upgraded"
			else:
				upgrade_button.text = "Cost: " + str(cost)
			update_description()


func update_labels() -> void:
	$VisualUpgradePath/PathProgressContainer/CurrentProgress.text = str(upgrade_path.get_current_upgrade_count())
	$VisualUpgradePath/PathProgressContainer/PathLength.text = str(upgrade_path.get_upgrade_count())


func update_description():
	description_label.text = upgrade_path.get_next_upgrade_description()
