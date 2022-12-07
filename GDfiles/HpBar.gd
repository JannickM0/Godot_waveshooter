extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hp_bar = get_node("./")
export var player_path : NodePath
onready var player = get_node(player_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	hp_bar.value = player.hp
