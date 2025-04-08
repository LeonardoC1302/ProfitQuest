extends Node2D

@export var player_path: NodePath
@export var pickup_distance := 16.0
@export var follow_offset := Vector2(5, 8)
@export var follow_speed := 100

var player: Node2D
var is_following := false

func _ready():
	player = get_node_or_null("../../Player")
	if player == null:
		print("❌ Player not found! Check the path in Inspector.")

func _process(delta):
	if player == null:
		return

	# Distance to player
	var distance = global_position.distance_to(player.global_position)

	# Pickup
	if Input.is_action_just_pressed("grab") and not is_following and distance <= pickup_distance:
		is_following = true
		print("Picked up")

	# Drop
	if Input.is_action_just_pressed("drop") and is_following:
		is_following = false
		var random_offset = randi_range(-15, 15)
		self.global_position = player.global_position + Vector2(random_offset, 10)
		print("Dropped")

	# Smooth follow if picked up
	if is_following:
		var target_pos = player.global_position + follow_offset
		global_position = global_position.lerp(target_pos, follow_speed * delta)
