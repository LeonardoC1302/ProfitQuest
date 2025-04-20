extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Enable input pickup
	mouse_filter = Control.MOUSE_FILTER_STOP


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Load the new scene
		get_tree().change_scene_to_file("res://Scenes/customization.tscn")
