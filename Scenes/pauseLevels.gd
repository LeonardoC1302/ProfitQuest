extends Node2D

@onready var pause_menu = $CanvasLayer/Pause

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

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
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
