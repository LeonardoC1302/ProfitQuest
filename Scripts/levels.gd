extends StaticBody2D

@export var player : NodePath  # Esto sigue bien

@export var escena_nivel: String = "res://Scenes/tutorial.tscn"
@export var nivel_id: int = 1
@export var interact_distance: float = 20

var player_node: CharacterBody2D  # Aquí guardaremos el nodo real

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
			entrar_al_nivel()

func entrar_al_nivel():
	print("🎮 Entrando al nivel ", nivel_id)
	get_tree().change_scene_to_file(escena_nivel)
