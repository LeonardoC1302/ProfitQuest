extends Control

var playerName = ""
var password = ""
var register = false
var user_file_path = "user://usuarios.json"
var tween: Tween = null 

func _ready():
	if not FileAccess.file_exists(user_file_path):
		var file = FileAccess.open(user_file_path, FileAccess.WRITE)
		file.store_string("{}")
		file.close()
	$ColorRect/MensajeLabel.visible = true
	$ColorRect/MensajeLabel.modulate.a = 0.0 

func mostrar_mensaje(texto: String, color := Color.RED) -> void:
	var label = $ColorRect/MensajeLabel
	label.text = texto
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.modulate.a = 0.0  
	label.visible = true

	# Cancela tween anterior si existe y está activo
	if tween and tween.is_running():
		tween.kill()

	# Crea nuevo tween
	tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)  
	tween.tween_interval(1.5) 
	tween.tween_property(label, "modulate:a", 0.0, 0.5)  

func _on_button_pressed():
	playerName = $ColorRect/LineEdit.text.strip_edges()
	password = $ColorRect/LineEdit2.text.strip_edges()

	if playerName == "" or password == "":
		mostrar_mensaje("Usuario o contraseña vacíos.")
		return

	var file = FileAccess.open(user_file_path, FileAccess.READ)
	var raw_text = file.get_as_text()
	file.close()

	var user_data = JSON.parse_string(raw_text)
	if typeof(user_data) != TYPE_DICTIONARY:
		user_data = {}

	if register:
		if user_data.has(playerName):
			mostrar_mensaje("Usuario ya existe.")
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
			mostrar_mensaje("Usuario registrado con éxito.", Color.GREEN)
	else:
		if user_data.has(playerName) and user_data[playerName]["password"] == password:
			print("Inicio de sesión exitoso.")
			PlayerData.username = playerName
			PlayerData.data = user_data[playerName]["data"]
			PlayerData.load_customization_from_user()
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		else:
			mostrar_mensaje("Usuario o contraseña incorrectos.")

func _on_button_2_pressed() -> void:
	register = !register
	if register:
		$ColorRect/Label3.text = "Registro"
		$ColorRect/Button2.text = "Iniciar Sesión"
		$ColorRect/Label4.text = "Pulsar el botón para iniciar sesión"
	else:
		$ColorRect/Label3.text = "Inicio de sesión"
		$ColorRect/Button2.text = "Registrarse"
		$ColorRect/Label4.text = "Pulsar el botón para registrarse"
