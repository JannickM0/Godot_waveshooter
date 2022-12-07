extends KinematicBody

var path = []
var path_node = 0

#stats
export var hp : int
export var speed : int
export var damage : int
export var turn_speed : int
export var nav_num : String

#state machine
enum {
	CHASE,
	ATTACK
}

var state = CHASE

onready var nav = get_node("../../Navs/Navigation" + nav_num)
onready var player = $"../../Player"
onready var enemy = $"."
onready var eyes = $'./Head'
onready var anim_player = $'AnimationPlayer'

onready var ray = get_node("Head/Gun/Ray")
onready var laser_scaler = get_node("Head/Laser/Scaler")
onready var laser_cast = get_node("Head/Laser/RayCast")

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
		player.b_bucks += 5
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
	laser()
	if not anim_player.is_playing():
		anim_player.play("Att1")
		player.hp -= damage


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


func _on_SightArea_body_entered(body):
	if body.is_in_group("Player"):
		
		var i = 1
		var collider_is_player = true
		while collider_is_player and i < 3:
			var raycast = ray.get_child(i-1)
			i += 1
			if raycast.is_colliding() and raycast.get_collider().is_in_group("Player"):
				collider_is_player = true
			else:
				collider_is_player = false
				
		if collider_is_player:
			state = ATTACK

func _on_SightArea_body_exited(body):
	if body.is_in_group("Player"):
		state = CHASE

func laser():
	var distance
	
	# Check for a raycast collision.
	if laser_cast.get_collider(): 
		# Calculating the distance between the laser and a collision point.
		distance = transform.origin.distance_to(laser_cast.get_collision_point())
		# Scaler is scaling to the collision point.
		laser_scaler.scale.z = distance
	else:
		# If the raycast is not colliding  with anything then the Scaler's scale is long as the raycast length.
		laser_scaler.scale.z = laser_cast.cast_to.z
