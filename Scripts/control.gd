extends Control

var playerName = ""
var password = ""
var register = false
var user_file_path = "user://usuarios.json"

func _ready():
	if not FileAccess.file_exists(user_file_path):
		var file = FileAccess.open(user_file_path, FileAccess.WRITE)
		file.store_string("{}")
		file.close()

func _on_button_pressed():
	playerName = $ColorRect/LineEdit.text.strip_edges()
	password = $ColorRect/LineEdit2.text.strip_edges()

	if playerName == "" or password == "":
		print("Usuario o contraseña vacíos")
		return

	var file = FileAccess.open(user_file_path, FileAccess.READ)
	var raw_text = file.get_as_text()
	file.close()

	var user_data = JSON.parse_string(raw_text)
	if typeof(user_data) != TYPE_DICTIONARY:
		user_data = {}

	if register:
		if user_data.has(playerName):
			print("Usuario ya existe.")
		else:
			user_data[playerName] = {
				"password": password,
				"data": {
					"presupuesto": 10000,
					"earnings": 0,
					"customization": {},
					"progress": { "1": {"score": 0} }
				}
			}
			var file_write = FileAccess.open(user_file_path, FileAccess.WRITE)
			file_write.store_string(JSON.stringify(user_data))
			file_write.close()
			print("Usuario registrado con éxito.")
	else:
		if user_data.has(playerName) and user_data[playerName]["password"] == password:
			print("Inicio de sesión exitoso.")
			PlayerData.username = playerName
			PlayerData.data = user_data[playerName]["data"]
			PlayerData.load_customization_from_user()
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
