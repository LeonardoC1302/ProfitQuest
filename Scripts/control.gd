extends Control
# Variable para guardar el nombre
var nombre_jugador = ""

func _on_button_pressed():
	var line_edit = $LineEdit
	nombre_jugador = line_edit.text
	print("Nombre del jugador: ", nombre_jugador)
	
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
