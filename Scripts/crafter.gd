extends StaticBody2D

@export var interact_distance: float = 30
@export var station_name: String = "MixerStation"

var player: CharacterBody2D
var crafting_db

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node_or_null("../../Player")
	if player == null:
		print("Player not found!")
	
	# Obtener referencia a la base de datos de crafteo
	crafting_db = get_node_or_null("/root/CraftingDb")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player and Input.is_action_just_pressed("interact"):
		var distance = global_position.distance_to(player.global_position)
		if distance <= interact_distance:
			print("Interact (E) pressed near crafter station: ", station_name)
			crafting_options()

func crafting_options():
	print("Crafting DB: ", crafting_db)
	var available_recipes = crafting_db.get_recipes_for_station(station_name)
	print("Available recipes for ", station_name, ": ", available_recipes.size())
	if available_recipes.size() > 0:
		var selected_recipe = available_recipes[0]
		craft_item(selected_recipe["recipe"], selected_recipe["product"])

func craft_item(recipe, product):
	var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
	if inventario_node:
		inventario_node.craftRecipe(recipe, product)
