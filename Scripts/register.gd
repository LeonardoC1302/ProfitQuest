extends StaticBody2D

@export var spawn_distance: float = 30
@export var sellableItems = []

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
		if spawn_distance >= distance:
			#print("Interact (E) pressed near register")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			var items = inventario_node.getItems()
			var selected = inventario_node.getSelectedSlot()
			var item_node = get_node("/root/Game/Items/IceCream")
			if selected != null:
				var itemName = items[selected]['nombre']
				var itemQty = items[selected]['cantidad']
				#print("Cantidad: ", itemQty, " Ceil: ", ceil(float(itemQty) / 2))
				if itemName in sellableItems:
					inventario_node.deleteItemSlot(selected)
					var price = item_node.sell_price
					player.earnings += price * itemQty
					player.gain_points(100, itemQty)
					print("Ganancias de jugador: ", player.earnings)
				else:
					player.message("Este producto no \n se puede vender")
			else:
				player.message("No seleccionó \n ningún objeto \n para vender")
				
