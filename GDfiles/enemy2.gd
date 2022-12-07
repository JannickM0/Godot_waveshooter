extends KinematicBody

var path = []
var path_node = 0

#stats
var hp = 30
var speed = 20
var turn_speed = 8

#state machine
enum {
	CHASE,
	ATTACK
}

var state = CHASE

onready var nav = get_parent()
onready var player = $"../../Player"
onready var enemy = $"."
onready var eyes = $'./Eyes'
onready var anim_player = $'AnimationPlayer'

func _ready():
	pass

func _process(delta):
	eyes.look_at(player.global_transform.origin, Vector3.UP)
	rotate_y(deg2rad(eyes.rotation.y * turn_speed))#beweegt het hele lichaam met de snelheid van TURNSPEED in de richting eyes kijken op de y axis
	eyes.rotate_x(deg2rad(eyes.rotation.x * turn_speed * 2))

func _physics_process(delta):
	if hp <= 0:
		queue_free()
		player.score += 10
		player.b_bucks += 100
		player.kills += 1

	match state:
		CHASE:
			chase()
		ATTACK:
			attack()		
		
func chase():
		if path_node < path.size():
			var direction = (path[path_node] - global_transform.origin)
			if direction.length() < 1:
				path_node += 1
			else:
				move_and_slide(direction.normalized() * speed, Vector3.UP)
	
func attack():
	anim_player.play("Att1")


func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0


func _on_Timer_timeout():
	move_to(player.global_transform.origin)


func _on_Attrange_body_entered(body):
	if body.is_in_group("Player"):
		state = ATTACK


func _on_Attrange_body_exited(body):
	if body.is_in_group("Player"):
		state = CHASE


func _on_Hand_R_body_entered(body):
	if body.is_in_group("Player"):
		body.hp -= 10
