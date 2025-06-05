extends Node2D


@export var player_path: NodePath
@export var pickup_distance := 16.0
@export var follow_offset := Vector2(5, 8)
@export var follow_speed := 80
@export var item_id: int = 1  # ID o tag del objeto
@export var item_unit: String = ""

@export var sell_price: int = 0

var cupboard: Node2D
var player: Node2D
var is_following:= false
var data = {}

func set_data(new_data):
	data = new_data
	# podés usarlo por ejemplo para mostrar el nombre o ícono si querés

func _ready():
	player = get_node_or_null("../../Player")
	if player == null:
		print("Player not found! Check the path in Inspector.")

func _process(delta):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	# Pickup
	if Input.is_action_just_pressed("grab") and not is_following and distance <= pickup_distance:
		player.register_item_pickup(item_id)
		player.hold = true
		is_following = true

	# Drop
	if Input.is_action_just_pressed("drop") and is_following:
		is_following = false
		var random_offset = randi_range(-15, 15)
		global_position = player.global_position + Vector2(random_offset, 10)
		player.hold = false
		player.register_item_drop(item_id)
		
	# Smooth follow if picked up
	if is_following:
		var target_pos = player.global_position + follow_offset
		global_position = global_position.lerp(target_pos, follow_speed * delta)
		
	cupboard = get_node_or_null("../../Stations/Cupboard")
	if cupboard == null:
		return

	var distance2 = player.global_position.distance_to(cupboard.global_position)
	if distance2 <= cupboard.interact_distance and Input.is_action_just_pressed("interact") and self.is_following:
		self.queue_free()
