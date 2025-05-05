extends Control
# Variable para guardar el nombre
var playerName = ""
var password = ""
var register = false
var user_file_path = "user://usuarios.json"

func _ready():
	# Crear archivo si no existe
	print(register)
	if not FileAccess.file_exists(user_file_path):
		var file = FileAccess.open(user_file_path, FileAccess.WRITE)
		file.store_string("{}")
		file.close()

func _on_button_pressed():
	var usernameInput = $ColorRect/LineEdit
	playerName = usernameInput.text.strip_edges()
	
	var passwordInput = $ColorRect/LineEdit2
	password = passwordInput.text.strip_edges()
	
	if playerName == "" or password == "":
		print("Usuario o contraseña vacíos")
		return
	
	var file = FileAccess.open(user_file_path, FileAccess.READ)
	var user_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if register:
		if user_data.has(playerName):
			print("⚠️ Usuario ya existe.")
		else:
			user_data[playerName] = password
			var file_write = FileAccess.open(user_file_path, FileAccess.WRITE)
			file_write.store_string(JSON.stringify(user_data))
			file_write.close()
			print("✅ Usuario registrado con éxito.")
	else:
		if user_data.has(playerName) and user_data[playerName] == password:
			print("Inicio de sesión exitoso.")
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		else:
			print("Usuario o contraseña incorrectos.")
			
func _on_button_2_pressed() -> void:
	register = !register
	if register:
		$ColorRect/Button2.text = "Registrarse"
	else:
		$ColorRect/Button2.text = "Iniciar sesión"
	print(register)
