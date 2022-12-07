extends Control

onready var anim_player = $AnimationPlayer
onready var label = $"Label"
var wave : int

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("fade_out")
	label.text = "Wave " + str(wave)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !anim_player.is_playing():
		queue_free()

