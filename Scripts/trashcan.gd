extends Node2D  # o el tipo que uses para tu basurero

@export var interact_distance: float = 30
var player: CharacterBody2D
var crafting_db
var used: bool = false
var usage_count: int = 0  # contador de usos
const MAX_USES: int = 3  # máximo de usos permitidos

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
			if usage_count >= MAX_USES:
				player.message("Este basurero\n ya no se\n puede usar más.")
				return
			
			print("Interact (E) pressed near trash bin")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			if inventario_node:
				var selected_item = inventario_node.get_selected_item()
				if selected_item:
					recycle_item(selected_item, inventario_node)
				else:
					player.message("No seleccionó\n níngún\n ingrediente\n o producto")

func recycle_item(item, inventario_node):
	var item_name = item["nombre"]
	var cantidad = item["cantidad"]
	
	# Verificar si el item es un producto conocido
	if item_name in crafting_db.recipes:
		self.used = true
		usage_count += 1  # incremento de uso
		player.message("Reciclando \nproducto: \n" + item_name)
		
		var recipe = crafting_db.recipes[item_name]["recipe"]
		var recipe_multiplier = cantidad
		
		inventario_node.delete_selected_item()
		
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

	elif item_name in crafting_db.ingredient_prices:
		self.used = true
		usage_count += 1  # incremento de uso
		player.message("Reciclando\n ingrediente\n suelto: " + item_name)
		
		var price = crafting_db.ingredient_prices[item_name]
		var refund = int(ceil(price * cantidad * 0.5))
		print("Precio unitario:", price, "Cantidad:", cantidad, "→ Reembolso:", refund)
		
		if refund > 0:
			inventario_node.delete_selected_item()
			player.presupuesto += refund
			print("Reembolso entregado al jugador: ₡", refund)
		else:
			print("No hay valor de reciclaje para:", item_name)

	else:
		player.message("Este ítem \n no se puede \n reciclar o no está \n en la base de datos: \n" + item_name)
