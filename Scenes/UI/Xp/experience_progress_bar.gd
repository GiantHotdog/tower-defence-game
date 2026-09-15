class_name ExperienceProgressBar
extends Control


signal level_up


@export var total_xp:int = 0:
	set(value):
		total_xp = value
		Globals.set_experience(value)
@export var character_count:int = 20
## A second xp value that may lag behind the source of truth to make nice animations
var visual_xp:int = total_xp

var health_full_char:String = "█"
var health_empty_char:String = "░"
var add_xp_tween:Tween
var level:int = 0

var level_up_particles_scene:PackedScene = load("res://Scenes/UI/Xp/level_up_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(1).timeout
	#gain_xp(50, .5)
	#await get_tree().create_timer(.25).timeout
	#gain_xp(50, .5)
	#await get_tree().create_timer(1).timeout
	#get_tree().change_scene_to_file("res://Scenes/UI/GlobalUpgradeTree/upgrade_tree.tscn")
	total_xp = Globals.get_experience()
	visual_xp = total_xp
	_update_labels(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_labels()


func _update_labels(emit_signals:bool = true):
	# Update the bar that shows the progress through the label
	var current_level:int = Globals.calculate_level(visual_xp)
	var current_xp_progress:float = Globals.calculate_experience_within_level(current_level, visual_xp)
	var level_xp_requirement:int = int(Globals.calculate_experience_required_for_level_up(current_level))
	var health_percent:float = current_xp_progress / level_xp_requirement
	var health_full_char_count:int = ceil(health_percent * character_count)
	var output:String = ""
	for i in range(health_full_char_count):
		output += health_full_char
		
	for i in range(character_count - health_full_char_count):
		output += health_empty_char
		
	%BarLabel.text = output
	
	# Update the text
	%XPTextLabel.text = "%03d/%03d" % [int(current_xp_progress), level_xp_requirement]
	
	# Emit level up signals
	while level < current_level:
		level += 1
		if emit_signals:
			level_up.emit()


func gain_xp(amount:int, time_period:float = 0.5, update_signal:Signal=Signal()):
	print("ADDED " + str(amount) + " XP")
	total_xp += amount
	
	if update_signal:
		print("Awaiting signal")
		await update_signal
		print("Signal emitted")
	
	if add_xp_tween and add_xp_tween.is_running():
		await add_xp_tween.finished
	add_xp_tween = get_tree().create_tween()
	add_xp_tween.set_trans(Tween.TRANS_QUAD)
	add_xp_tween.set_ease(Tween.EASE_OUT)
	add_xp_tween.tween_property(self, "visual_xp", total_xp, time_period)


func _on_level_up() -> void:
	var particles:GPUParticles2D = level_up_particles_scene.instantiate()
	%LevelUpParticlesContainer.add_child(particles)
	#print("Levels:")
	#print("Total xp:")
