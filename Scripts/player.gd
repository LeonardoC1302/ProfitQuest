class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

const MAX_ITEM_ID = 100  # Ajustalo según cuántos tipos de ítems vas a usar
var items_collected := []

@onready var animated_sprite_2d: AnimationPlayer = $CustomPlayer/AnimationPlayer
@onready var customPlayer: Node2D = $CustomPlayer
@onready var headSprite: Sprite2D = $CustomPlayer/Head
@onready var eyebrowsSprite: Sprite2D = $CustomPlayer/Eyebrows
@onready var eyesSprite: Sprite2D = $CustomPlayer/Eyes
@onready var earsSprite: Sprite2D = $CustomPlayer/Ears
@onready var bodySprite: Sprite2D = $CustomPlayer/Body
@onready var outlineSprite: Sprite2D = $CustomPlayer/Outline
@onready var contrastSrpite: Sprite2D = $CustomPlayer/Contrast
@onready var state_machine: PlayerStateMachine = $StateMachine

func _ready() -> void:
	state_machine.Initialize(self)
	# Inicializar el array con ceros
	items_collected.resize(MAX_ITEM_ID)
	for i in range(MAX_ITEM_ID):
		items_collected[i] = 0
	pass

func _process(delta: float) -> void:
	direction.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	direction.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * 200  # o tu velocidad personalizada
		move_and_slide()

func set_color(color_name, color):
	match color_name:
		"Head":
			headSprite.self_modulate = color
		"Eyebrows":
			eyebrowsSprite.self_modulate = color
		"Eyes":
			eyesSprite.self_modulate = color
		"Ears":
			earsSprite.self_modulate = color
		"Body":
			bodySprite.self_modulate = color
		"Contrast":
			contrastSrpite.self_modulate = color
		"Outline":	
			outlineSprite.self_modulate = color

func SetDirection() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	# Scale to affect child elements
	customPlayer.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	#animated_sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func UpdateAnimation(state : String) -> void:
	animated_sprite_2d.play("character/" + state + "_" + AnimDirection())
	pass	

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func register_item_pickup(item_id: int) -> void:
	if item_id >= 0 and item_id < items_collected.size():
		items_collected[item_id] += 1
		print("Picked up item ID:", item_id, " | Total:", items_collected[item_id])
	else:
		print("Item ID out of range:", item_id)
		
func register_item_drop(item_id: int) -> void:
	if item_id >= 0 and item_id < items_collected.size():
		if items_collected[item_id] > 0:
			items_collected[item_id] -= 1
			print("Dropped item ID:", item_id, " | Remaining:", items_collected[item_id])
		else:
			print("No items of ID", item_id, "to drop.")
	else:
		print("Item ID out of range:", item_id)

func getCollectedItems():
	return items_collected
	
func resetCollectedItems(itemsMap):
	var names = []
	for key in itemsMap:
		names.append(itemsMap[key]["nombre"])
	
	var gameNode = get_tree().get_root().get_node("Game")
	for child in gameNode.get_children():
		if child.name in names or child.name.begins_with("@"):
			child.queue_free()
	for i in range(MAX_ITEM_ID):
		items_collected[i] = 0
