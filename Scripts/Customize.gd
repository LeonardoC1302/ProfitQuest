extends Button

@export var target_scene: String = "res://Scenes/customization.tscn"

func _ready():
	# Conecta la señal pressed() si no está conectada desde el editor
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file(target_scene)
