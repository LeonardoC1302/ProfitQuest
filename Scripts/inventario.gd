extends Control

const NUM_SLOTS = 9
const SLOT_SCENE = preload("res://Scenes/Slot.tscn")

var inventario = []
var slot_seleccionado = null

@export var itemMap = {}

@export var drop_scene_map = {
	"Cone": preload("res://Scenes/cone.tscn"),
	"Milk": preload("res://Scenes/milk.tscn"),
	"Sugar": preload("res://Scenes/sugar.tscn"),
	"Egg": preload("res://Scenes/egg.tscn"),
	"Vainilla": preload("res://Scenes/vainilla.tscn"),
	"IceCream": preload("res://Scenes/iceCream.tscn")
}

@export var player: Node2D
@export var world_2d_node: Node2D



func _ready():
	print("Current inventario path: ", get_path())
	inicializar_inventario()
	rellenar_inventario_prueba()  # Optional test data
	crear_slots()
	actualizar_interfaz()

func inicializar_inventario():
	inventario.clear()
	for i in range(NUM_SLOTS):
		inventario.append(null)

func rellenar_inventario_prueba():
	pass
	# Example test data
	#inventario[0] = {"nombre": "Banana", "cantidad": 64, "icono": preload("res://Assets/Ingredients/banana.png")}
	#inventario[3] = {"nombre": "Cono", "cantidad": 64, "icono": preload("res://Assets/Ingredients/Cone.png")}
	#inventario[8] = {"nombre": "Mango", "cantidad": 64, "icono": preload("res://Assets/Ingredients/mango.png")}

func crear_slots():
	var grid = $CenterContainer/GridContainer
	# Remove any existing slots
	for child in grid.get_children():
		child.queue_free()
	# Create new slots
	for i in range(NUM_SLOTS):
		var slot_instance = SLOT_SCENE.instantiate()
		grid.add_child(slot_instance)
		slot_instance.inventario_ref = self
		slot_instance.slot_index = i
		
		
func procesar_click(index):
	if slot_seleccionado == null:
		# Seleccionar el slot si contiene un ítem
		if inventario[index] != null:
			slot_seleccionado = index
	else:
		if index == slot_seleccionado:
			slot_seleccionado = null
			actualizar_interfaz()
			actualizar_visual_seleccion()
			return
		else:
			# Intercambiar entre slots
			var temp = inventario[index]
			inventario[index] = inventario[slot_seleccionado]
			inventario[slot_seleccionado] = temp
			slot_seleccionado = null

	actualizar_interfaz()
	actualizar_visual_seleccion()
	
func drop_selected_item():
	if slot_seleccionado != null and inventario[slot_seleccionado] != null:
		var item_data = inventario[slot_seleccionado]
		var item_name = item_data["nombre"]
		print("Intentando dropear:", item_name)

		print("Buscando en drop_scene_map:", item_name)
		print("Claves disponibles:", drop_scene_map.keys())

		if drop_scene_map.has(item_name):
			var drop_scene = drop_scene_map[item_name].instantiate()
			print("Instancia creada:", drop_scene)

			if player and world_2d_node:
				var drop_offset = Vector2(32, 0)
				drop_scene.global_position = player.global_position + drop_offset
				world_2d_node.add_child(drop_scene)
			else:
				print("⚠️ No se asignó player o world_2d_node")

			# ✅ Usar cantidad del inventario
			if item_data["cantidad"] > 1:
				item_data["cantidad"] -= 1
			else:
				inventario[slot_seleccionado] = null
				slot_seleccionado = null

			actualizar_interfaz()
			actualizar_visual_seleccion()
		else:
			print("No se encontró drop_scene_map para:", item_name)
	else:
		print("No hay item seleccionado")

func _input(event):
	if event.is_action_pressed("drop"):
		drop_selected_item()

	
func actualizar_visual_seleccion():
	var slots = $CenterContainer/GridContainer.get_children()
	for slot in slots:
		slot.actualizar_visual_seleccionado(slot.slot_index == slot_seleccionado)

func actualizar_interfaz():
	var slots = $CenterContainer/GridContainer.get_children()
	for i in range(NUM_SLOTS):
		var slot_data = inventario[i]
		var slot = slots[i]
		var icon = slot.get_node("TextureRect")
		var label = slot.get_node("Label")
		if slot_data != null:
			icon.texture = slot_data["icono"]
			label.text = str(slot_data["cantidad"])
		else:
			icon.texture = null
			label.text = ""

# New function that updates the inventory when the player interacts with the cupboard.
func process_cupboard_interaction():
	print("Interacted with cupboard: updating inventory")
	# Example logic: add a new item if there is an empty slot.
	var new_item = {"nombre": "Mango", "cantidad": 10, "icono": preload("res://Assets/Ingredients/Mango.png")}
	for i in range(NUM_SLOTS):
		if inventario[i] == null:
			inventario[i] = new_item
			break
	actualizar_interfaz()
	
func searchRecipe(recipe):
	# Create a dictionary to track ingredients in inventory
	var inventory_counts = {}
	
	# Count all ingredients in inventory
	for i in range(NUM_SLOTS):
		if inventario[i] != null:
			var item_name = inventario[i]["nombre"]
			var item_quantity = inventario[i]["cantidad"]
			
			if item_name in inventory_counts:
				inventory_counts[item_name] += item_quantity
			else:
				inventory_counts[item_name] = item_quantity
	
	# Check if we have enough of each ingredient
	for ingredient in recipe:
		var ingredient_name = ingredient["name"]
		var required_quantity = ingredient["quantity"]
		
		if ingredient_name not in inventory_counts or inventory_counts[ingredient_name] < required_quantity:
			print("Missing ingredient: ", ingredient_name, " (need ", required_quantity, ")")
			return false
	
	return true
	
func process_register_interaction():
	print("Interacted with cash register, selling product...")
	# De momento solo se va a vender el primer item que tenga en el inventario (solo se quita, aún no está lo de dinero)
	for i in range(NUM_SLOTS):
		if inventario[i] != null:
			inventario[i] = null # De momento solo se borra
			break
	actualizar_interfaz()
	
func collectItems(items):
	for item in items.size():
		var amount = items[item]
		if amount > 0:
			var new_item = {"nombre": itemMap[item]['nombre'], "cantidad": amount, "icono" : load(itemMap[item]['icono'])}
			for i in range(NUM_SLOTS):
				if inventario[i] != null and inventario[i]['nombre'] == new_item['nombre']:
					inventario[i]['cantidad'] += new_item['cantidad']
					break
				elif inventario[i] == null:
					inventario[i] = new_item
					break
	actualizar_interfaz()

func addItem(item):
	var added = false
	var firstNull = null
	for i in range(NUM_SLOTS):
		if firstNull == null and inventario[i] == null:
			firstNull = i
		if inventario[i] != null and inventario[i]['nombre'] == item['nombre']:
			inventario[i]['cantidad'] += item['cantidad']
			added = true
			break
	if not added and firstNull != null:
		inventario[firstNull] = item.duplicate()
	actualizar_interfaz()
	
func getMap():
	return itemMap
	
func getItems():
	return inventario
	
func getSelectedSlot():
	return slot_seleccionado
	
func deleteItemSlot(itemSlot):
	slot_seleccionado = null
	inventario[itemSlot] = null
	actualizar_interfaz()
	actualizar_visual_seleccion()
	
func craftRecipe(recipe, product):
	if searchRecipe(recipe):
		# Remove ingredients from inventory based on required quantities
		for ingredient in recipe:
			var ingredient_name = ingredient["name"]
			var required_quantity = ingredient["quantity"]
			var remaining_quantity = required_quantity
			
			# Continue removing items until we've satisfied the required quantity
			while remaining_quantity > 0:
				for i in range(NUM_SLOTS):
					if inventario[i] != null and inventario[i]['nombre'] == ingredient_name:
						if inventario[i]['cantidad'] > remaining_quantity:
							# We have more than needed, just reduce the quantity
							inventario[i]['cantidad'] -= remaining_quantity
							remaining_quantity = 0
							break
						else:
							# We'll use up this stack completely
							remaining_quantity -= inventario[i]['cantidad']
							inventario[i] = null
							break
				
				# Safety check - if we can't find any more of this item but still need more
				if remaining_quantity > 0:
					print("Error: Couldn't find enough of ", ingredient_name)
					break
		
		# Add the crafted product to inventory
		addItem(product)
	else:
		print("No se tienen todos los ingredientes para craftear")
	
