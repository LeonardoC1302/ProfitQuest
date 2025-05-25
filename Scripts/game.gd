extends Node2D

@onready var timer = $CanvasLayer/LevelTimer
@onready var menu_panel = $CanvasLayer/Objectives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("objective"):  # define esta acción en Input Map
		menu_panel.visible = true
	else:
		menu_panel.visible = false


func start_timer():
	# TODO: Set the timer according to a difficulty, it can be stored in the Autoload 
	timer.set_timer(120)
	
