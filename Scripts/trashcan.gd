extends StaticBody2D

@export var interact_distance: float = 30
@export var recipes = {}

var player: CharacterBody2D
var maxUses = 3

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
			print("Interact (E) pressed near trash can")
			var inventario_node = get_node("/root/Game/CanvasLayer/Inventario")
			if maxUses > 0:
				if inventario_node:
					var items = inventario_node.getItems()
					var selected = inventario_node.getSelectedSlot()
					if selected != null:
						var itemName = items[selected]['nombre']
						var itemQty = items[selected]['cantidad']
						#print("Cantidad: ", itemQty, " Ceil: ", ceil(float(itemQty) / 2))
						if itemName == 'IceCream':
							inventario_node.deleteItemSlot(selected)
							var product1 = {"nombre": "Milk", "cantidad": ceil(float(itemQty) / 2), "icono": preload("res://Assets/Ingredients/Milk.png")}
							var product2 = {"nombre": "Sugar", "cantidad": ceil(float(itemQty) / 2), "icono": preload("res://Assets/Ingredients/Sugar.png")}
							var product3 = {"nombre": "Egg", "cantidad": ceil(float(itemQty) / 2), "icono": preload("res://Assets/Ingredients/Egg.png")}
							var product4 = {"nombre": "Vanilla", "cantidad": ceil(float(itemQty) / 2), "icono": preload("res://Assets/Ingredients/Vanilla.png")}
							
							inventario_node.addItem(product1)
							inventario_node.addItem(product2)
							inventario_node.addItem(product3)
							inventario_node.addItem(product4)
							maxUses -= 1
						else:
							print("No es un producto crafteable!!")
			else:
				print("No quedan usos disponibles!!")
