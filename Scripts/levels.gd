extends StaticBody2D

@export var player : NodePath
@export var escena_nivel: String = "res://Scenes/level_2.tscn"
@export var nivel_id: int = 2  # nivel actual (el que este script representa)
@export var required_score: int = 100  # puntaje necesario para desbloquear este nivel
@export var interact_distance: float = 40

var player_node: CharacterBody2D

func _ready():
	player_node = get_node_or_null(player)
	if player_node == null:
		print("❌ Player not found!")
	else:
		print("✅ Player found:", player_node.name)

func _process(_delta):
	if player_node and Input.is_action_just_pressed("interact"):
		var distance = global_position.distance_to(player_node.global_position)
		if distance <= interact_distance:
			if PlayerData.is_level_unlocked(nivel_id, required_score):
				entrar_al_nivel()
			else:
				player_node.message("Nivel %d bloqueado.\n Se requieren\n %d puntos\n en el nivel\n anterior." % [nivel_id, required_score]
)
				print("🔒 Nivel ", nivel_id, " bloqueado. Se requieren ", required_score, " puntos en el nivel anterior.")

func entrar_al_nivel():
	print("🎮 Entrando al nivel ", nivel_id)
	get_tree().change_scene_to_file(escena_nivel)
