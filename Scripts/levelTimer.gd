extends Node2D

@onready var label = $Label
@onready var timer = $Timer
@export var objective: NodePath
@export var player: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_node(objective):
		pass
	else:
		print("⚠️ No se encontró el nodo de objetivos")

# Time for the timer in seconds
func set_timer(time_left: int):
	timer.start(time_left)
	
func subtract_time(time: int) -> void:
	var remaining = timer.time_left - time
	timer.stop()
	
	if remaining > 0:
		timer.start(remaining)
	else:
		# Si el tiempo restante es 0 o menos, finaliza el juego inmediatamente
		time_left_to_finish()

func time_left_to_finish():
	var p = get_node_or_null(player)
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	if time_left == 0:
		var objectives_node = get_node(objective) 
		objectives_node.assign_points()
		set_process(false)
		p.end_game()
	return [minute, second]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%02d:%02d" % time_left_to_finish()
