extends Node2D  # o el tipo que uses para tu basurero

@export var interact_distance: float = 30
var player: CharacterBody2D
var crafting_db

func _ready() -> void:
	player = get_node_or_null("../../Player")
	if player == null:
		print("Player not found!")
	
	# Obtener referencia a la base de datos de crafteo
	crafting_db = get_node("/root/CraftingDatabase")

func _process(delta: float) -> void:
	if player and Input.is_action_just_pressed("interact"):
		var distance = global_position.distance_to(player.global_position)
		if distance <= interact_distance:
			print("Interact (E) pressed near trash bin")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			if inventario_node:
				# Asumimos que hay alguna forma de obtener el item seleccionado
				var selected_item = inventario_node.get_selected_item()
				if selected_item:
					recycle_item(selected_item, inventario_node)

func recycle_item(item, inventario_node):
	var item_name = item["nombre"]
	
	# Verificar si el item es un producto conocido
	if item_name in crafting_db.recipes:
		print("Reciclando:", item_name)
		
		var recipe = crafting_db.recipes[item_name]["recipe"]
		
		# Eliminar el item del inventario
		inventario_node.remove_selected_item()
		
		# Devolver el 50% de los materiales (redondeando hacia abajo)
		for ingredient in recipe:
			var ingredient_name = ingredient["name"]
			var return_quantity = int(ingredient["quantity"] * 0.5)  # 50% redondeado hacia abajo
			
			if return_quantity > 0:
				# Obtener el icono del ingrediente desde la base de datos
				var ingredient_icon = crafting_db.get_ingredient_icon(ingredient_name)
				
				# Añadir los materiales recuperados al inventario
				inventario_node.addItem({
					"nombre": ingredient_name,
					"cantidad": return_quantity,
					"icono": ingredient_icon
				})
				
				print("Devuelto:", ingredient_name, " x ", return_quantity)
	else:
		print("Este ítem no se puede reciclar o no está en la base de datos")
