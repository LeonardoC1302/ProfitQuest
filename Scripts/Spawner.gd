extends StaticBody2D

@export var spawn_scene: PackedScene  # Drag the .tscn prefab into this in the Inspector
@export var spawn_distance: float = 20
@export var costo: int = 100

var player: CharacterBody2D

func _ready():
	# Find the player by path — adjust as needed!
	player = get_node_or_null("../../Player")
	if player == null:
		print("Player not found!")


func _process(_delta):
	if player and Input.is_action_just_pressed("interact"):
		var distance = global_position.distance_to(player.global_position)
		if distance <= spawn_distance:
			#print("E")
			spawn_object()

func spawn_object():
	var random_offset = randi_range(-15, 15)

	if spawn_scene and player:
		if player.presupuesto >= costo:
			player.presupuesto -= costo

			var instance = spawn_scene.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = global_position + Vector2(random_offset, 24)

			print("Producto creado. Presupuesto restante:", player.presupuesto)
		else:
			print("No tenés suficiente presupuesto. Se requieren ", costo)
	else:
		print("⚠️ No spawn_scene asignado o player no encontrado.")
