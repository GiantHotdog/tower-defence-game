class_name Defragmenter
extends BaseTower


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


func pulse():
	var tween:Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($PulseCircle, "outer_radius", attack_range, 0.75)
	tween.tween_callback(reset_pulse)


func _on_pulse_timer_timeout() -> void:
	pulse()


func reset_pulse():
	#await get_tree().create_timer(0.5).timeout
	$PulseCircle.outer_radius = 0


func _on_attack_area_2d_area_entered(area: Area2D) -> void:
	super(area)
	var enemy:BaseEnemy = area.get_parent()
	if enemy.is_cloaked:
		enemy.is_cloaked = false

func _on_attack_area_2d_area_exited(area: Area2D) -> void:
	super._on_attack_area_2d_area_exited(area)
