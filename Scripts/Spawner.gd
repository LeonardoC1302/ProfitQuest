extends StaticBody2D

@export var spawn_scene: PackedScene
@export var spawn_distance: float = 20
@export var costo: int = 100

var player: CharacterBody2D
var info_panel: CanvasLayer

func _ready():
	player = get_tree().get_current_scene().get_node_or_null("Player")
	info_panel = $info_panel

	if player == null:
		print("Player not found in current scene")
	
	if info_panel:
		info_panel.visible = false
		info_panel.get_node("Panel/Label").text = "Costo: " + str(costo)

		if spawn_scene:
			var temp_instance = spawn_scene.instantiate()

			# Buscar entre los hijos inmediatos del nodo raíz (ej. Cone, Milk, etc.)
			var sprite_node: Sprite2D = null
			for child in temp_instance.get_children():
				if child is Sprite2D:
					sprite_node = child
					break

			if sprite_node:
				var icon_texture = sprite_node.texture
				info_panel.get_node("Panel/TextureRect").texture = icon_texture
				print("✅ Sprite2D encontrado y textura aplicada: ", icon_texture)
			else:
				print("❌ No se encontró un Sprite2D dentro del ingrediente instanciado")

			temp_instance.queue_free()

	else:
		print("⚠️ info_panel no encontrado.")

func _process(_delta):
	if not player:
		return

	var distance = global_position.distance_to(player.global_position)

	if info_panel:
		info_panel.visible = distance <= spawn_distance

	if Input.is_action_just_pressed("interact") and distance <= spawn_distance:
		spawn_object()

func spawn_object():
	var random_offset = randi_range(-15, 15)

	if spawn_scene and player:
		if player.presupuesto >= costo:
			player.presupuesto -= costo

			var instance = spawn_scene.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = global_position + Vector2(random_offset, 24)

			print("Producto creado. Presupuesto restante:", player.presupuesto)
		else:
			print("No tenés suficiente presupuesto. Se requieren ", costo)
	else:
		print("⚠️ No spawn_scene asignado o player no encontrado.")
