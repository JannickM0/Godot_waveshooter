extends Spatial

onready var gun_name = get_node(".").name

var damage
var auto
onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():	
	anim_player.play("default_pos")
	auto = Globals.WEAPONS[gun_name]["auto"]
	damage = Globals.WEAPONS[gun_name]["damage"]
	
	#stel het wapen is 2 keer geupgrade dan is upgraded 3 en de base damage van het wapen is
	#100 dan word het 100 * (3/10 + 1) = 100 * 1.3 = 130
	damage = damage * (Globals.player["weapons"][gun_name]["upgraded"] / 10 + 1)
