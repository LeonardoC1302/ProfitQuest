extends Node

@onready var label = $Label3 
@onready var star1 = $Star
@onready var star2 = $Star2
@onready var star3 = $Star3

@onready var lblstar1 = $LabelStar1
@onready var lblstar2 = $LabelStar2
@onready var lblstar3 = $LabelStar3

@onready var nextlvl = $Label4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print( Player.evaluation[0])
	label.text = "Puntaje final: %d" % Player.final_score
	lblstar1.text = "%d" % Player.evaluation[0]
	lblstar2.text = "%d" % Player.evaluation[1]
	lblstar3.text = "%d" % Player.evaluation[2]
	
	if Player.final_score < Player.evaluation[2]:
		star3.visible = false
	if Player.final_score < Player.evaluation[1]:
		star2.visible = false
	if Player.final_score < Player.evaluation[0]:
		star1.visible = false
		var difference = Player.evaluation[0] - Player.final_score
		nextlvl.text = "Faltan %dpts para desbloquear \n el siguiente nivel" % difference
	else:
		nextlvl.text = "Siguiente Nivel Desbloqueado"
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventKey and event.is_action_pressed("grab"):
		get_tree().change_scene_to_file("res://Scenes/levels.tscn")
