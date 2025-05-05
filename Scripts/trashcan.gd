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
				# Obtener el item seleccionado
				var selected_item = inventario_node.get_selected_item()
				if selected_item:
					recycle_item(selected_item, inventario_node)

func recycle_item(item, inventario_node):
	var item_name = item["nombre"]
	
	# Verificar si el item es un producto conocido
	if item_name in crafting_db.recipes:
		print("Reciclando:", item_name)
		
		var recipe = crafting_db.recipes[item_name]["recipe"]
		var product_quantity = crafting_db.recipes[item_name]["product"]["cantidad"]
		
		# Calcular cuántas veces se ejecuta la receta por cada unidad del producto
		var recipe_multiplier = item['cantidad']
		
		# Eliminar el item seleccionado del inventario (ya sea reduciendo cantidad o eliminándolo)
		inventario_node.delete_selected_item()
		
		# Devolver el 50% de los materiales (redondeando hacia abajo)
		for ingredient in recipe:
			var ingredient_name = ingredient["name"]
			
			# Calcular cuántos ingredientes se usaron para crear 1 unidad del producto
			var ingredient_per_unit = ingredient["quantity"] * recipe_multiplier
			
			# Calcular cuántos ingredientes retornar (50% redondeando hacia abajo)
			var return_quantity = ceil(ingredient_per_unit * 0.5)
			
			if return_quantity > 0:
				# Obtener el icono del ingrediente desde el CraftingDatabase
				var ingredient_icon = crafting_db.get_ingredient_icon(ingredient_name)

				# Añadir los materiales recuperados al inventario
				if ingredient_icon != null:
					inventario_node.addItem({
						"nombre": ingredient_name,
						"cantidad": return_quantity,
						"icono": ingredient_icon
					})
					
					print("Devuelto:", ingredient_name, " x ", return_quantity)
				else:
					print("No se encontró icono para:", ingredient_name)
	else:
		print("Este ítem no se puede reciclar o no está en la base de datos")
