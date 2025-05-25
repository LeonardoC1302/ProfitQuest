extends Node2D  # o el tipo que uses para tu basurero

@export var interact_distance: float = 30
var player: CharacterBody2D
var crafting_db
var used:bool = false

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
				# Obtener el item seleccionado
				var selected_item = inventario_node.get_selected_item()
				if selected_item:
					recycle_item(selected_item, inventario_node)

func recycle_item(item, inventario_node):
	var item_name = item["nombre"]
	var cantidad = item["cantidad"]
	
	# Verificar si el item es un producto conocido
	if item_name in crafting_db.recipes:
		self.used = true
		print("Reciclando producto:", item_name)
		
		var recipe = crafting_db.recipes[item_name]["recipe"]
		var recipe_multiplier = cantidad
		
		# Eliminar el item seleccionado del inventario
		inventario_node.delete_selected_item()
		print("Eliminado del inventario:", item_name, "x", cantidad)
		
		# Devolver el 50% de los materiales (redondeando hacia arriba)
		for ingredient in recipe:
			var ingredient_name = ingredient["name"]
			var ingredient_per_unit = ingredient["quantity"] * recipe_multiplier
			var return_quantity = int(ceil(ingredient_per_unit * 0.5))
			
			if return_quantity > 0:
				var ingredient_icon = crafting_db.get_ingredient_icon(ingredient_name)
				if ingredient_icon != null:
					inventario_node.addItem({
						"nombre": ingredient_name,
						"cantidad": return_quantity,
						"icono": ingredient_icon
					})
					print("Devuelto:", ingredient_name, "x", return_quantity)
				else:
					print("No se encontró icono para:", ingredient_name)

	# Si no es producto, pero sí un ingrediente suelto con precio
	elif item_name in crafting_db.ingredient_prices:
		self.used = true
		print("Reciclando ingrediente suelto:", item_name)
		
		# Calcular reembolso: 50% del precio del ingrediente
		var price = crafting_db.ingredient_prices[item_name]
		var refund = int(ceil(price * cantidad * 0.5))
		print("Precio unitario:", price, "Cantidad:", cantidad, "→ Reembolso:", refund)
		
		if refund > 0:
			# Eliminar del inventario
			inventario_node.delete_selected_item()
			print("Eliminado del inventario:", item_name, "x", cantidad)
			
			# Dar el dinero al jugador
			player.presupuesto+=refund
			print("Reembolso entregado al jugador: ₡", refund)
		else:
			print("No hay valor de reciclaje para:", item_name)
	
	# No es reciclable
	else:
		print("Este ítem no se puede reciclar o no está en la base de datos:", item_name)
