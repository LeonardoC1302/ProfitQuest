extends Node2D

@onready var timer = $CanvasLayer/LevelTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_timer():
	# TODO: Set the timer according to a difficulty, it can be stored in the Autoload 
	timer.set_timer(120)
	
