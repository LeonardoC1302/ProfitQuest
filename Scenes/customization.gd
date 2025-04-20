extends Node2D

@onready var headColorPicker: ColorPickerButton = $VBoxContainer/HeadContainer/HeadColorPicker
@onready var eyebrowsColorPicker: ColorPickerButton = $VBoxContainer/EyebrowsContainer/EyebrowsColorPicker
@onready var eyesColorPicker: ColorPickerButton = $VBoxContainer/EyesContainer/EyesColorPicker
@onready var earsColorPicker: ColorPickerButton = $VBoxContainer/EarsContainer/EarsColorPicker
@onready var bodyColorPicker: ColorPickerButton = $VBoxContainer/BodyContainer/BodyColorPicker
@onready var contrastColorPicker: ColorPickerButton = $VBoxContainer/ContrastContainer/ContrastColorPicker
@onready var outlineColorPicker: ColorPickerButton = $VBoxContainer/OutlineContainer/OutlineColorPicker

var save_path := "user://player_customization.ini"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_customization()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



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
	
func save_customization():
	var config_file := ConfigFile.new()
	config_file.set_value("Customization", "Head", headColorPicker.color)
	config_file.set_value("Customization", "Eyebrows", eyebrowsColorPicker.color)
	config_file.set_value("Customization", "Eyes", eyesColorPicker.color)
	config_file.set_value("Customization", "Ears", earsColorPicker.color)
	config_file.set_value("Customization", "Body", bodyColorPicker.color)
	config_file.set_value("Customization", "Contrast", contrastColorPicker.color)
	config_file.set_value("Customization", "Outline", outlineColorPicker.color)
	
	var error := config_file.save(save_path)
	if error:
		print("Save customization error: ", error)

func load_customization():
	var config_file := ConfigFile.new()
	var error := config_file.load(save_path)
	
	if error:
		print("Load customization error: ", error)
		headColorPicker.color = Color.BISQUE
		%Player.set_color("Head", Color.BISQUE)
		eyebrowsColorPicker.color = Color.CORNSILK
		%Player.set_color("Eyebrows", Color.CORNSILK)
		eyesColorPicker.color = Color.CYAN
		%Player.set_color("Eyes", Color.CYAN)
		earsColorPicker.color = Color.CRIMSON
		%Player.set_color("Ears", Color.CRIMSON)
		bodyColorPicker.color = Color.BISQUE
		%Player.set_color("Body", Color.BISQUE)
		contrastColorPicker.color = Color.AQUAMARINE
		%Player.set_color("Contrast", Color.AQUAMARINE)
		outlineColorPicker.color = Color.BLACK
		%Player.set_color("Outline", Color.BLACK)
		return
		
	headColorPicker.color = config_file.get_value("Customization", "Head", Color.BISQUE)
	%Player.set_color("Head", headColorPicker.color)
	eyebrowsColorPicker.color = config_file.get_value("Customization", "Eyebrows", Color.CORNSILK)
	%Player.set_color("Eyebrows", eyebrowsColorPicker.color)
	eyesColorPicker.color = config_file.get_value("Customization", "Eyes", Color.CYAN)
	%Player.set_color("Eyes", eyesColorPicker.color)
	bodyColorPicker.color = config_file.get_value("Customization", "Body", Color.BISQUE)
	%Player.set_color("Body", bodyColorPicker.color)
	contrastColorPicker.color = config_file.get_value("Customization", "Contrast", Color.AQUAMARINE)
	%Player.set_color("Contrast", contrastColorPicker.color)
	outlineColorPicker.color = config_file.get_value("Customization", "Outline", Color.BLACK)
	%Player.set_color("Outline", outlineColorPicker.color)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
