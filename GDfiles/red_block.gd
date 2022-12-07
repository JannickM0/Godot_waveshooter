extends RigidBody


var random_force = Globals.random_num(-5, 5)
var random_rotation_x = Globals.random_num(0, 360)
var random_rotation_y = Globals.random_num(0, 360)
var random_rotation_z = Globals.random_num(0, 360)

onready var mesh = get_node("MeshInstance")
onready var anim_player = get_node("AnimationPlayer")

var random_que_free_time = Globals.random_num(5, 20)
onready var quee_free_timer = get_node("QueFreeTimer")
onready var shrink_timer = get_node("ShrinkTimer")

# Called when the node enters the scene tree for the first time.
func _ready():

	quee_free_timer.wait_time = random_que_free_time
	quee_free_timer.start()

	anim_player.play("shrink")
	
	self.rotate_y(random_rotation_y)
	self.rotate_x(random_rotation_x)
	self.rotate_z(random_rotation_z)
	apply_impulse(transform.basis.z , Vector3(0, random_force, 0))
	




func _on_QueFreeTimer_timeout():
	queue_free()


#func _on_ShrinkTimer_timeout():
#	anim_player.play("shrink")
