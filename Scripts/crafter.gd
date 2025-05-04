extends StaticBody2D

@export var interact_distance: float = 30
@export var recipes = {}

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
		if distance <= interact_distance:
			print("Interact (E) pressed near crafter")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			if inventario_node:
				var items = inventario_node.getItems()
				# Acá implementar algo para seleccionar la receta, de momento va a estar alambrado

				# Acá se implementa la receta como tal, se debe validar que se tengan todos los ingredientes antes de quitarlos}
				var recipe = ['Milk', 'Cone']
				var product = {"nombre": "iceCream", "cantidad": 1, "icono": preload("res://Assets/Ingredients/IceCream.png")}
				inventario_node.craftRecipe(recipe, product)
