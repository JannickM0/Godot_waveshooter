extends VBoxContainer

onready var kills = $"Kills"
onready var waves = $"Waves"
onready var score = $"Score"
onready var money = $"Money"


# Called when the node enters the scene tree for the first time.
func _ready():
	kills.text = "Kills: " + str(Globals.player["total_kills"])
	score.text = "Score: " + str(Globals.player["total_score"])
	waves.text = "Waves: " + str(Globals.player["total_waves"])
	money.text = "B bucks: " + str(Globals.player["b_bucks"])
