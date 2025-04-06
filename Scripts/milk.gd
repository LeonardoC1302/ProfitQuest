extends Node2D

@export var player_path: NodePath
@export var follow_offset := 32.0  # Distancia hacia adelante
@export var speed := 200.0

var should_follow := false
var player: Node2D

func _ready():
	player = get_node(player_path)

func _process(delta):
	if player == null:
		return

	# Detectar si se presiona ESPACIO y estamos cerca
	var distance_to_player = global_position.distance_to(player.global_position)
	if Input.is_action_just_pressed("ui_accept") and distance_to_player < 100:
		should_follow = true

	if should_follow:
		# Intentar acceder a la dirección del jugador
		var direction = Vector2.RIGHT  # dirección por defecto si no sabemos hacia dónde va

		if player.has_method("get_direction"):
			direction = player.get_direction()

		var target_position = player.global_position + direction.normalized() * follow_offset
		var move = (target_position - global_position).normalized() * speed * delta
		global_position += move
