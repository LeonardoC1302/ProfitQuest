extends Node

@export var player: NodePath
@export var timer: NodePath

@export var objetivo_earnings: int
@export var objetivo_budget: int
#@export var objetivo_bidget_limite: int

@onready var obj1 = get_parent().get_node("CanvasLayer/Objectives/Obj1/Check")
@onready var obj2 = get_parent().get_node("CanvasLayer/Objectives/Obj2/Check")
var cumplio_earnings = false
var cumplio_budget = false


func _ready():
	obj1.visible = false
	obj2.visible = false

func _input(event):
	var excluded_keys = [KEY_W, KEY_A, KEY_S, KEY_D]

	if event is InputEventKey and event.pressed and event.keycode not in excluded_keys:
		var p = get_node_or_null(player)
		check_objectives1()

		if cumplio_earnings:
			print("✅ Ganancias alcanzadas")
			obj1.visible = true
		else:
			obj1.visible = false

		if cumplio_budget:
			print("✅ EL presupuesto se encuentra en el rango deseado")
			obj2.visible = true
		else:
			obj2.visible = false
			
func check_objectives1():
	#se pueden ir agregando objetivos para diferentes niveles
	#depsues agregar UI para ver objetivos disponibles
	var p = get_node_or_null(player)
	if p == null:
		print("⚠️ No se encontró el nodo del jugador")
		return
	
	var earnings = p.earnings
	var budget = p.presupuesto
	
	self.cumplio_earnings = earnings >= objetivo_earnings
	self.cumplio_budget = budget >= 0 and budget <= objetivo_budget

func assign_points():
	check_objectives1()
	var p = get_node_or_null(player)
	if cumplio_earnings:
		p.score += 250
	if cumplio_budget:
		p.score += 250
