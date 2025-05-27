extends Node

var username = ""
var data = {}
const INI_PATH := "user://player_customization.ini"

func load_customization_from_user():
	if not data.has("customization"):
		return

	var valid = false
	for part in ["Head", "Eyebrows", "Eyes", "Ears", "Body", "Contrast", "Outline"]:
		if data["customization"].has(part):
			valid = true
			break

	if not valid:
		return

	var config = ConfigFile.new()
	for part in ["Head", "Eyebrows", "Eyes", "Ears", "Body", "Contrast", "Outline"]:
		var raw = data["customization"].get(part, "")
		var color
		if typeof(raw) == TYPE_STRING:
			color = _string_to_color(raw)
		else:
			color = raw
		config.set_value("Customization", part, color)
	config.save(INI_PATH)

# función auxiliar para parsear string "(r,g,b,a)" → Color
func _string_to_color(s: String) -> Color:
	var stripped = s.strip_edges().replace("(", "").replace(")", "")
	var parts = stripped.split(",")
	if parts.size() != 4:
		return Color.BLACK
	return Color(parts[0].to_float(), parts[1].to_float(), parts[2].to_float(), parts[3].to_float())

func save_customization_to_user():
	var config = ConfigFile.new()
	if config.load(INI_PATH) == OK:
		data["customization"] = {
			"Head": config.get_value("Customization", "Head", Color.BISQUE),
			"Eyebrows": config.get_value("Customization", "Eyebrows", Color.CORNSILK),
			"Eyes": config.get_value("Customization", "Eyes", Color.CYAN),
			"Ears": config.get_value("Customization", "Ears", Color.CRIMSON),
			"Body": config.get_value("Customization", "Body", Color.BISQUE),
			"Contrast": config.get_value("Customization", "Contrast", Color.AQUAMARINE),
			"Outline": config.get_value("Customization", "Outline", Color.BLACK)
		}

func save_player_progress(player: Node):
	data["presupuesto"] = player.presupuesto
	data["earnings"] = player.earnings
	data["score"] = player.score

	var file = FileAccess.open("user://usuarios.json", FileAccess.READ)
	var all_users = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(all_users) == TYPE_DICTIONARY and all_users.has(username):
		all_users[username]["data"] = data
		var file_write = FileAccess.open("user://usuarios.json", FileAccess.WRITE)
		file_write.store_string(JSON.stringify(all_users))
		file_write.close()
