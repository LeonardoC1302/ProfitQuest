extends Panel

func _ready():
	# Enable input pickup
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Load the new scene
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
