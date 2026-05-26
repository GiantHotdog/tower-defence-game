class_name AOEProjectile
extends BaseProjectile

@export var explode_final_scale:float = 20

@onready var AoeArea:Area2D = $AoeArea
@onready var tracking_area:Area2D = $TrackArea

var is_exploding:bool = false


func _process(delta: float) -> void:
	if is_instance_valid(target):
		var direction_to_target:Vector2 = global_position.direction_to(target.global_position) 
		rotation = direction_to_target.angle() + PI / 2
		var move_vector = Vector2.UP.rotated(rotation) * move_speed * delta
		position += move_vector
	elif not is_exploding:
		# If the target no longet exists, attempt to find a new one
		var closest_node:BaseEnemy = null
		var closest_node_distance:float
		for child in tracking_area.get_overlapping_areas():
			var parent = child.get_parent()
			if parent is BaseEnemy:
				# if there is currently no node, just fill in the basic one to avoid a crash by accessing its parameters later
				if not closest_node:
					closest_node = parent
					closest_node_distance = global_position.distance_to(closest_node.global_position)
				elif closest_node_distance > global_position.distance_to(parent.global_position):
					closest_node = parent
					closest_node_distance = global_position.distance_to(closest_node.global_position)
		target = closest_node
	if not target and not is_exploding:
		# If no target has been found, remove the projectile
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_exploding: 
		return
	var parent = area.get_parent()
	if parent is BaseEnemy:
		is_exploding = true
		await get_tree().physics_frame
		for attacking in AoeArea.get_overlapping_areas():
			var enemy:BaseEnemy = attacking.get_parent()
			enemy.health -= damage
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(explode_final_scale, explode_final_scale), 0.2)
		tween.parallel().tween_property(self, "modulate",Color(1, 1, 1, 0), 0.3)
		tween.tween_callback(_on_tween_finished)

func _on_tween_finished():
	await get_tree().create_timer(0.1).timeout
	queue_free()
