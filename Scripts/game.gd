extends Node2D

@onready var timer = $CanvasLayer/LevelTimer
@onready var menu_panel = $CanvasLayer/Objectives
@onready var pause_menu = $CanvasLayer/Pause

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false
	
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("objective"):  # define esta acción en Input Map
		menu_panel.visible = true
	else:
		menu_panel.visible = false

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func start_timer():
	# TODO: Set the timer according to a difficulty, it can be stored in the Autoload 
	timer.set_timer(180)
	
func pause_game():
	get_tree().paused = true
	pause_menu.visible = true

func resume_game():
	get_tree().paused = false
	pause_menu.visible = false

func _on_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/levels.tscn")

func _on_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
