class_name ZeroDayEnemy
extends BaseEnemy


func _on_invulnerability_timer_timeout() -> void:
	is_invulnerable = false
	%ShieldSprite.visible = false

#func _process(delta: float) -> void:
	#%ShieldDamageParticlesPivot.look_at(get_viewport().get_mouse_position())


func play_shield_particles(attacker_global_pos:Vector2):
	%ShieldDamageParticlesPivot.look_at(attacker_global_pos)
	%ShieldDamageParticles.restart()
