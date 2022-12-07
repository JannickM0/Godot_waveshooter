extends Spatial

onready var kills = $"StatContainer/Kills"
onready var wave = $"StatContainer/Wave"
onready var score = $"StatContainer/Score"
onready var money = $"StatContainer/Money"

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	kills.text = "Kills: " + str(Globals.player_ingame["kills"])
	score.text = "Score: " + str(Globals.player_ingame["score"])
	wave.text = "Wave: " + str(Globals.player_ingame["wave"])
	money.text = "B bucks: " + str(Globals.player_ingame["b_bucks"])

func _on_Button_pressed():
	get_tree().change_scene("res://Assets/ui/titelscreen/Titlescreen.tscn")
