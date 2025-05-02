extends Control

const NUM_SLOTS = 9
const SLOT_SCENE = preload("res://Scenes/Slot.tscn")

var inventario = []
var slot_seleccionado = null

@export var itemMap = {}

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
		if inventario[index] != null:
			slot_seleccionado = index
	else:
		if index == slot_seleccionado:
			slot_seleccionado = null
			actualizar_visual_seleccion()
			return


		var temp = inventario[index]
		inventario[index] = inventario[slot_seleccionado]
		inventario[slot_seleccionado] = temp

		slot_seleccionado = null

	actualizar_interfaz()
	actualizar_visual_seleccion()
	
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
	var nombres_en_inventario = []
	for item in inventario:
		if item != null:
			nombres_en_inventario.append(item["nombre"])

	for nombre in recipe:
		if nombre not in nombres_en_inventario:
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
		if inventario[i] != null and inventario[i]['nombre'] == item['nombre'] :
			inventario[i]['cantidad'] += item['cantidad']
			added = true
			break
	if not added:
		inventario[firstNull] = item
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
		for i in range(NUM_SLOTS):
			if inventario[i] != null and inventario[i]['nombre'] in recipe:
				if inventario[i]['cantidad'] > 1:
					inventario[i]['cantidad'] -= 1
				else:
					inventario[i] = null
			
		addItem(product)
	else:
		print("No se tienen todos los ingredientes para craftear")
	
