class_name LogicGateTower
extends BaseTower


@export var laser_line_width:float = 10.0

@onready var laser_line:Line2D = $Laser
@onready var laser_spawn:Node2D = $Base/Turret/LaserSpawn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	laser_line.add_point(laser_line.to_local(laser_spawn.global_position))
	laser_line.add_point(laser_line.to_local(laser_spawn.global_position))
	
	ready_to_fire_turret_texture = load("res://Assets/Towers/Logic gate.svg")
	not_ready_to_fire_turret_texture = load("res://Assets/Towers/Logic gate.svg")
	display_name = "Logic Gate"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	laser_line.points[0] = laser_line.to_local(laser_spawn.global_position)
	if not is_attacking:
		update_laser()


func attack():
	update_turret_rotation()
	update_laser()
	
	is_attacking = true
	laser_line.width = laser_line_width
	
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(laser_line, "width", 0, 0.2)
	tween.tween_callback(_finished_attacking)
	
	attack_cooldown_timer.start()
	turret.texture = not_ready_to_fire_turret_texture
	can_attack = false
	
	target.health -= damage


func update_laser():
	if target:
		laser_line.points[1] = laser_line.to_local(target.global_position)
	else:
		laser_line.points[1] = laser_line.to_local(laser_spawn.global_position)

func _finished_attacking():
	is_attacking = false
