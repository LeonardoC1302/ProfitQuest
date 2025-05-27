extends Node2D

@onready var headColorPicker: ColorPickerButton = $VBoxContainer/HeadContainer/HeadColorPicker
@onready var eyebrowsColorPicker: ColorPickerButton = $VBoxContainer/EyebrowsContainer/EyebrowsColorPicker
@onready var eyesColorPicker: ColorPickerButton = $VBoxContainer/EyesContainer/EyesColorPicker
@onready var earsColorPicker: ColorPickerButton = $VBoxContainer/EarsContainer/EarsColorPicker
@onready var bodyColorPicker: ColorPickerButton = $VBoxContainer/BodyContainer/BodyColorPicker
@onready var contrastColorPicker: ColorPickerButton = $VBoxContainer/ContrastContainer/ContrastColorPicker
@onready var outlineColorPicker: ColorPickerButton = $VBoxContainer/OutlineContainer/OutlineColorPicker

const SAVE_PATH := "user://player_customization.ini"

func _ready() -> void:
	load_customization()

func _on_head_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Head", color)

func _on_eyebrows_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Eyebrows", color)

func _on_eyes_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Eyes", color)

func _on_ears_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Ears", color)

func _on_body_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Body", color)

func _on_contrast_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Contrast", color)

func _on_outline_color_picker_color_changed(color: Color) -> void:
	%Player.set_color("Outline", color)

func _on_save_button_pressed() -> void:
	save_customization()
	PlayerData.save_customization_to_user()
	PlayerData.save_player_progress(%Player)
	print("✅ Personalización guardada en player_customization.ini y sincronizada")

func save_customization():
	var config = ConfigFile.new()
	config.set_value("Customization", "Head", headColorPicker.color)
	config.set_value("Customization", "Eyebrows", eyebrowsColorPicker.color)
	config.set_value("Customization", "Eyes", eyesColorPicker.color)
	config.set_value("Customization", "Ears", earsColorPicker.color)
	config.set_value("Customization", "Body", bodyColorPicker.color)
	config.set_value("Customization", "Contrast", contrastColorPicker.color)
	config.set_value("Customization", "Outline", outlineColorPicker.color)
	config.save(SAVE_PATH)

func load_customization():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		print("No se pudo cargar configuración. Usando valores por defecto")
		return

	headColorPicker.color = config.get_value("Customization", "Head", Color.BISQUE)
	eyebrowsColorPicker.color = config.get_value("Customization", "Eyebrows", Color.CORNSILK)
	eyesColorPicker.color = config.get_value("Customization", "Eyes", Color.CYAN)
	earsColorPicker.color = config.get_value("Customization", "Ears", Color.CRIMSON)
	bodyColorPicker.color = config.get_value("Customization", "Body", Color.BISQUE)
	contrastColorPicker.color = config.get_value("Customization", "Contrast", Color.AQUAMARINE)
	outlineColorPicker.color = config.get_value("Customization", "Outline", Color.BLACK)

	%Player.set_color("Head", headColorPicker.color)
	%Player.set_color("Eyebrows", eyebrowsColorPicker.color)
	%Player.set_color("Eyes", eyesColorPicker.color)
	%Player.set_color("Ears", earsColorPicker.color)
	%Player.set_color("Body", bodyColorPicker.color)
	%Player.set_color("Contrast", contrastColorPicker.color)
	%Player.set_color("Outline", outlineColorPicker.color)

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
