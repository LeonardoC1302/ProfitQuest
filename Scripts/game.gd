extends Node2D

@onready var timer = $CanvasLayer/LevelTimer
@onready var menu_panel = $CanvasLayer/Objectives
@onready var pause_menu = $CanvasLayer/Pause
@onready var manual = $CanvasLayer/Manual

@export var current_lvl: int
@export var stars: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false
	manual.visible = false
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
	timer.set_timer(210)
	
func pause_game():
	get_tree().paused = true
	pause_menu.visible = true

func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	
func open_manual():
	manual.visible = true

func close_manual():
	manual.visible = false

func _on_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/levels.tscn")

func _on_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_button_4_pressed() -> void:
	open_manual()
	await get_tree().process_frame
	pause_game()

func _on_exit_pressed() -> void:
	close_manual()

func _on_exit_2_pressed() -> void:
	close_manual()
	
func _on_exit_3_pressed() -> void:
	close_manual()

func _on_exit_4_pressed() -> void:
	close_manual()
