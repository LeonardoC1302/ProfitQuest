extends Node2D

@onready var label = $Label
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Time for the timer in seconds
func set_timer(time_left: int):
	timer.start(time_left)

func time_left_to_finish():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%02d:%02d" % time_left_to_finish()
