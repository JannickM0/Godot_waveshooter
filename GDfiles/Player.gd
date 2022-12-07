extends KinematicBody

var hp = Globals.player.hp
var normalSpeed : int = Globals.player.speed
var sprintSpeed : float = Globals.player.speed * 1.5
var weapons = Globals.player.weapons

var kills : int
var speed : float
var damage
var weapon
var audio
var auto
var active_weapon : int = 0  
var weapon_amount
var doubleJump = true

var b_bucks : int = 0
var score : int = 0

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = Globals.settings["mouse"]["mouse_sense"] / 50 / 10
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var hand = $Head/Camera/Hand
onready var camera = $Head/Camera
var anim_player
onready var aim_cast = $Head/Camera/AimCast
onready var hand_anim_player = $Head/Camera/AnimationPlayer

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	weapon_amount = hand.get_child_count()#houd bij hoeveel wapens er zijn zodat je niet naar een wapen kan switchen die niet bestaat. kan errors veroorzaken
	get_weapon_info()

func quit_to_lobby():
	Globals.player.b_bucks += b_bucks
	Globals.player.total_score += score
	Globals.player.total_kills += kills
	Globals.player.total_waves += get_node("../EnemySpawner").wave
	
	Globals.player_ingame.b_bucks = b_bucks
	Globals.player_ingame.score = score
	Globals.player_ingame.kills = kills
	Globals.player_ingame.wave = get_node("../EnemySpawner").wave
	Globals.save_data(Globals.player, Globals.PLAYER_PROGRES)
	Globals.switch_scene("res://Assets/ui/game_over/GameOver.tscn")
	#get_tree().change_scene("res://Assets/ui/game_over/GameOver.tscn")

func get_weapon_info():
	#informatie over het gekozen wapen krijgen aangezien niet alle wapens hetzelfde zijn
	weapon = (hand.get_child(active_weapon))#referentie naar het wapen dat in gebruik is waarin active wapen bijhoud welk wapen er gekozen is
	hand.get_child(active_weapon).visible = true
	
	#info over het wapen
	damage = weapon.damage
	anim_player = weapon.anim_player
	audio = weapon.audio_player
	auto = weapon.auto
	
func weapon_switch():
	for i in range(1, weapon_amount+1, 1):
		var weapon_str = "weapon" + str(i)
		if Input.is_action_pressed(weapon_str):#checkt welk nummer er ingedrukt was  en checkt 1 tm het aantal wapens dat de speler heeft
			var weapon_name = hand.get_child(i-1).gun_name
			if Globals.player["weapons"][weapon_name]["unlocked"]:
				hand.get_child(active_weapon).visible = false
				active_weapon = i-1#aangezien arrays en children van een node begint bij 0 maar active_weapon bij 1 moet er -1
				get_weapon_info()
		
func fire():
	if weapon.auto:
		if Input.is_action_pressed("att1"):
			fire_weapon()
	else:
		if Input.is_action_just_pressed("att1"):
			fire_weapon()
	

func fire_weapon():
	if not anim_player.is_playing():
		if aim_cast.is_colliding():
			var target = aim_cast.get_collider()
			if target.is_in_group("Enemy"):
				target.hp -= damage
	anim_player.play("Fire")
#	audio.play()

func _input(event):
	weapon_switch()
	
	if Input.is_action_pressed("unalive"):
		quit_to_lobby()
	
	if Input.is_action_just_released("esc"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#allow the player to sprint
	if Input.is_action_pressed("sprint"):
		speed = sprintSpeed
		hand_anim_player.playback_speed = 2
	else:
		speed = normalSpeed
		
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	if hp <= 0:
		quit_to_lobby()

	fire()
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	direction = Vector3()
	
	
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward"):
		hand_anim_player.playback_speed = 1
		hand_anim_player.play("walk")
	else:
		hand_anim_player.play("RESET")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or doubleJump):
		doubleJump = !doubleJump
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	#move_and_slide_with_snap(movement, snap, Vector3.UP)
	move_and_slide(movement, Vector3.UP)
