extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()


func _on_finished() -> void:
	queue_free()
