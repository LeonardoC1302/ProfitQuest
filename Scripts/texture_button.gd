extends TextureButton

var inventario_ref
var slot_index

var dragging = false
var drag_start_position = Vector2.ZERO
const DRAG_THRESHOLD = 10  # píxeles para considerar como arrastre

func _ready():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_filter = MOUSE_FILTER_STOP  # <- Clave para aceptar drops
	print("Slot botón listo para arrastrar. Slot index:", slot_index)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_start_position = event.position
			print("Click inicial detectado en slot:", slot_index)
		else:
			dragging = false
			print("Click liberado en slot:", slot_index)

	if event is InputEventMouseMotion and dragging:
		var distance = event.position.distance_to(drag_start_position)
		print("Moviendo mouse en slot:", slot_index, " - Distancia:", distance)
		if distance > DRAG_THRESHOLD:
			dragging = false
			print("¡Iniciando drag manual en slot:", slot_index, "!")
			start_drag()

func start_drag():
	print("start_drag llamado para slot:", slot_index)

	var data = {"from_index": slot_index}

	var preview = TextureRect.new()
	preview.texture = texture_normal
	preview.expand = true
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	force_drag(data, preview)

	print("force_drag ejecutado para slot:", slot_index)

func can_drop_data(position, data):
	print("can_drop_data evaluado en slot:", slot_index, " - Data recibida:", data)
	return true

func drop_data(position, data):
	print("drop_data ejecutado en slot:", slot_index, " - Desde índice:", data["from_index"])
	inventario_ref.procesar_drop(data["from_index"], slot_index)
