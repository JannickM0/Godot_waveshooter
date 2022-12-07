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

export var has_wheel : bool
var wheel
onready var nav = get_node("../../Navs/Navigation" + nav_num)
onready var player = $"../../Player"
onready var enemy = $"."
onready var head = $'./BodyMesh/Head'
onready var anim_player = $'AnimationPlayer'

var death_particle = preload("res://Assets/entities/enemies/death_effect/red_block.tscn")

func _ready():
	if has_wheel:
		wheel = get_node("BodyMesh/Wheel")

func _process(delta):
	head.look_at(player.global_transform.origin, Vector3.UP)
	rotate_y(deg2rad(head.rotation.y * turn_speed))#beweegt het hele lichaam met de snelheid van TURNSPEED in de richting eyes kijken op de y axis
	head.rotate_x(deg2rad(head.rotation.x * turn_speed * 2))

func _physics_process(delta):
	if hp <= 0:
		queue_free()
		player.score += 10
		player.b_bucks += 2
		player.kills += 1
		for i in range(1, 20):
			var particle = death_particle.instance()
			get_tree().get_root().add_child(particle)
			particle.translation = Vector3(self.translation.x, self.translation.y , self.translation.z)
	match state:
		CHASE:
			chase()
		ATTACK:
			chase()
			attack()		
		
func chase():
	if not anim_player.current_animation == "Att1":
		if has_wheel:
			wheel.rotate_x(deg2rad(-10))
		else:
			anim_player.play("walk")
		
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
	
func attack():
	if not anim_player.current_animation == "Att1":
		print("me go attack")
		anim_player.play("Att1")
		player.hp -= damage


func calculate_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0


func _on_Timer_timeout():
	calculate_path(player.global_transform.origin)


func _on_Attrange_body_entered(body):
	if body.is_in_group("Player"):
		state = ATTACK


func _on_Attrange_body_exited(body):
	if body.is_in_group("Player"):
		state = CHASE
