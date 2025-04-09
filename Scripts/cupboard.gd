extends StaticBody2D

@export var spawn_distance: float = 30

var player: CharacterBody2D

func _ready():
	player = get_node_or_null("../Player")
	if player == null:
		print("Player not found!")

func _process(_delta):
	if player and Input.is_action_just_pressed("interact"):
		var distance = global_position.distance_to(player.global_position)
		if distance <= spawn_distance:
			print("Interact (E) pressed near cupboard")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			if inventario_node:
				inventario_node.process_cupboard_interaction()
			else:
				print("Inventario node not found!")
