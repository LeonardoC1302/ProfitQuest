extends Node

@onready var label = $Label3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "Puntaje final: %d" % Player.final_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
