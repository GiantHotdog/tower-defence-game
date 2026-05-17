extends BaseTower


@onready var laser_line:Line2D = $Laser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	laser_line.add_point(laser_line.to_local(global_position))
	laser_line.add_point(laser_line.to_local(global_position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if target:
		laser_line.points[1] = laser_line.to_local(target.global_position)


func attack():
	attack_cooldown_timer.start()
	turret.texture = not_ready_to_fire_turret_texture
	can_attack = false
	var projectile:BaseProjectile = projectile_scene.instantiate()
	projectile.target = target
	projectile.damage = damage
	projectile.global_position = global_position
	add_child(projectile)
