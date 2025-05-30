extends Control

var leaderboard_font := preload("res://Assets/PressStart2P-Regular.ttf")

@onready var tab_niveles: TabContainer = $ColorRect/VBoxContainer/TabContainer

const USER_FILE := "user://usuarios.json"
const NIVELES := 3

func _ready():
	load_leaderboards()

func load_leaderboards():
	var file := FileAccess.open(USER_FILE, FileAccess.READ)
	var raw := file.get_as_text()
	file.close()

	var users: Dictionary = JSON.parse_string(raw)
	if typeof(users) != TYPE_DICTIONARY:
		print("❌ Error al leer usuarios.json")
		return

	for i in range(NIVELES):
		var lvl_id := str(i + 1)
		var leaderboard := []

		for username in users.keys():
			var udata = users[username].get("data", {})
			var progress = udata.get("progress", {})
			if progress.has(lvl_id):
				var score = progress[lvl_id].get("score", 0)
				leaderboard.append({ "name": username, "score": score })

		# Ordenar por score descendente
		leaderboard.sort_custom(func(a, b): return a["score"] > b["score"])

		var tab := tab_niveles.get_child(i)
		tab.clear() if tab.has_method("clear") else tab.get_children().map(func(c): c.queue_free())

		for j in range(min(10, leaderboard.size())):
			var entry: Dictionary = leaderboard[j]
			var label = Label.new()
			
			var icon := ""
			match j:
				0: icon = "🥇 "
				1: icon = "🥈 "
				2: icon = "🥉 "
			
			label.text = "%s%d. %s — %d pts" % [icon, j + 1, entry["name"], entry["score"]]
			label.add_theme_font_override("font", leaderboard_font)
			tab.add_child(label)



func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
