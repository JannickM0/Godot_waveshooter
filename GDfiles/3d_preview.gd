extends Spatial

onready var item = $Item




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	item.rotate_y(deg2rad(0.6))
