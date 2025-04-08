extends Control

const NUM_SLOTS = 9
const SLOT_SCENE = preload("res://Scenes/Slot.tscn")

var inventario = []
var slot_seleccionado = null

func _ready():
	inicializar_inventario()
	rellenar_inventario_prueba()
	crear_slots()
	actualizar_interfaz()
	actualizar_visual_seleccion()

func inicializar_inventario():
	inventario.clear()
	for i in range(NUM_SLOTS):
		inventario.append(null)

func rellenar_inventario_prueba():
	inventario[0] = {"nombre": "Banana", "cantidad": 64, "icono": preload("res://Assets/Ingredients/banana.png")}
	inventario[3] = {"nombre": "Cono", "cantidad": 64, "icono": preload("res://Assets/Ingredients/Cone.png")}
	inventario[8] = {"nombre": "Mango", "cantidad": 64, "icono": preload("res://Assets/Ingredients/mango.png")}

func crear_slots():
	var grid = $CenterContainer/GridContainer

	# Limpia slots existentes
	for child in grid.get_children():
		child.queue_free()

	# Crea nuevos slots
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
		var cantidad = slot.get_node("Label")

		if slot_data != null:
			icon.texture = slot_data["icono"]
			cantidad.text = str(slot_data["cantidad"])
		else:
			icon.texture = null
			cantidad.text = ""

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
