extends Camera2D

@export var follow_speed := 5.0

func _process(delta):
	if get_parent():
		var target_position = get_parent().global_position
		global_position = global_position.lerp(target_position, follow_speed * delta)
