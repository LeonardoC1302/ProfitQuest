extends Button

@export var target_scene: String = "res://Scenes/levels.tscn"

func _ready():
	# Conecta la señal pressed() si no está conectada desde el editor
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file(target_scene)

func _on_button_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Leaderboard.tscn")
