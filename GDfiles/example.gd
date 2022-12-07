

extends Spatial



func _ready():
	
	MijnFunctie()
	
	#var nummer
	
	#var nummer = 6
	
	#nummer = 6

	#var nummer = 2 + 2

	var x = 6
	var nummer = 1+ cos(x) * 1.5

var kubus = preload("res://RigidBody.tscn")


func _on_Timer_timeout():
	print("kubus ingespawned")
	var k = kubus.instance()



func MijnFunctie():
	var nummer = 2 + 2
