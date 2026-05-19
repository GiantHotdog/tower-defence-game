class_name AOEProjectile
extends BaseProjectile

@onready var AoeArea:Area2D = $AoeArea

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is BaseEnemy:
		await get_tree().physics_frame
		for attacking in AoeArea.get_overlapping_areas():
			var enemy:BaseEnemy = attacking.get_parent()
			enemy.health -= damage
