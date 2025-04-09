extends Control

const NUM_SLOTS = 9
const SLOT_SCENE = preload("res://Scenes/Slot.tscn")

var inventario = []

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
	# Example test data
	inventario[0] = {"nombre": "Banana", "cantidad": 64, "icono": preload("res://Assets/Ingredients/banana.png")}
	inventario[3] = {"nombre": "Cono", "cantidad": 64, "icono": preload("res://Assets/Ingredients/Cone.png")}
	inventario[8] = {"nombre": "Mango", "cantidad": 64, "icono": preload("res://Assets/Ingredients/mango.png")}

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
