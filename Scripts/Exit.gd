extends Button

func _ready():
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().quit()
