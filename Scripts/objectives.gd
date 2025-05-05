extends Node

@export var player: NodePath
@export var timer: NodePath

@export var objetivo_earnings: int = 1000
@export var objetivo_budget_restante: int = 100
@export var objetivo_bidget_limite: int = 5000

func _ready():
	pass

func check_objectives1():
	#se pueden ir agregando objetivos para diferentes niveles
	#depsues agregar UI para ver objetivos disponibles
	var p = get_node_or_null(player)
	if p == null:
		print("⚠️ No se encontró el nodo del jugador")
		return
	
	var earnings = p.earnings
	var budget = p.presupuesto
	
	var cumplio_earnings = earnings >= objetivo_earnings
	var cumplio_budget = budget >= objetivo_budget_restante and budget <= objetivo_bidget_limite

	print("🧾 Revisión de objetivos:")
	print("- Ganancias: ", earnings, "/", objetivo_earnings)
	print("- Budget restante: ", budget, " (rango permitido: ", objetivo_budget_restante, " - ", objetivo_bidget_limite, ")")

	if cumplio_earnings:
		print("✅ Ganancias alcanzadas")
	else:
		print("❌ No alcanzó las ganancias necesarias")
		
	if cumplio_budget:
		print("✅ El presupuesto se encuentra en el rango deseado")
	else:
		print("❌ No cumple con el presupuesto deseado")
