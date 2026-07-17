class_name LaserTower
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	laser_line.points[0] = laser_line.to_local(laser_spawn.global_position)
	if not is_attacking:
		update_laser()


func attack():
	update_turret_rotation()
	update_laser()
	#fire_text_laser()
	
	is_attacking = true
	laser_line.width = laser_line_width
	
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(laser_line, "width", 0, 0.2)
	tween.tween_callback(_finished_attacking)
	
	attack_cooldown_timer.start()
	turret.texture = not_ready_to_fire_turret_texture
	can_attack = false
	
	if not target.is_invulnerable:
		target.health -= calculated_damage
	else:
		if has_method("play_shield_particles"): 
			target.play_shield_particles(global_position)


func update_laser():
	if target:
		laser_line.points[1] = laser_line.to_local(target.global_position)
	else:
		laser_line.points[1] = laser_line.to_local(laser_spawn.global_position)

func _finished_attacking():
	is_attacking = false


func fire_text_laser():
	var distance = global_position.distance_to(target.global_position)
	var angle = global_position.angle_to_point(target.global_position)
	
	var text_beam:Label = Label.new()
	text_beam.add_theme_font_size_override("font_size", 24)
	add_child(text_beam)
	
	var character_count = int(distance / 16)
	var binary_string = ""
	for i in range(character_count):
		var rand = randf()
		if rand <= 0.45:
			binary_string += "1"
		elif rand >= 0.55:
			binary_string += "0"
		else:
			binary_string += " "
		
	text_beam.text = binary_string
	text_beam.rotation = angle
	text_beam.pivot_offset_ratio.y = 0.5
	print(text_beam.size.y)
	
	var tween = create_tween()
	tween.tween_property(text_beam, "modulate:a", 0.0, 0.1)
	tween.tween_callback(text_beam.queue_free)
