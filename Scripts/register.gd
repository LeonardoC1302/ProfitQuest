extends StaticBody2D

@export var spawn_distance: float = 30

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node_or_null("../../Player")
	if player == null:
		print("Player not found!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player and Input.is_action_just_pressed("interact"):
		var distance = global_position.distance_to(player.global_position)
		if distance <= spawn_distance:
			print("Interact (E) pressed near cash register")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			if inventario_node:
				inventario_node.process_register_interaction()
			else:
				print("Inventario node not found!")
