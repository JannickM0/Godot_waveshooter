extends ColorRect

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !anim_player.is_playing():
		queue_free()

