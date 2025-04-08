extends Control

var inventario_ref
var slot_index

func _ready():
	mouse_filter = MOUSE_FILTER_STOP

func _on_panel_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		inventario_ref.procesar_click(slot_index)

func actualizar_visual_seleccionado(es_seleccionado: bool):
	var panel = $Panel

	# Color inicial del panel
	var color_origen = panel.self_modulate
	var color_destino = Color(1, 1, 0.4, 1) if es_seleccionado else Color(1, 1, 1, 1)

	# Crear y ejecutar el tween
	var tween = create_tween()
	tween.tween_property(panel, "self_modulate", color_destino, 0.25) \
		.from(color_origen) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
