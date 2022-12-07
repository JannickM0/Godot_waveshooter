extends KinematicBody

var damage = 10

var ray_cast

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("att1"):
		#doe iets
		
		if ray_cast.is_colliding():
			var target = ray_cast.get_collider()
			if target.is_in_group("Enemy"):
				target.hp -= damage
