extends Node


var PLAYER_PROGRES = "res://Assets/game-data.json"

var SETTINGS = "res://Assets/settings.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var os = OS.get_name()
#	print("os is: ", os)
#	if os == "Windows":
#		PLAYER_PROGRES = "res://game-data.json"
#		SETTINGS = "res://settings.json"
#	elif os == "OSX":
#		PLAYER_PROGRES = "res://game-data.json"
#		SETTINGS = "res://settings.json"
	
	settings = load_data(settings, SETTINGS)
	settings = load_data(settings, SETTINGS)
	player = load_data(player, PLAYER_PROGRES)
	player = load_data(player, PLAYER_PROGRES)
	apply_settings()

const WEAPONS = {
	"pistol": {
		"auto": false,
		"damage": 10,
		"prijs": 0
	},
	"shotgun": {
		"auto": false,
		"damage": 50,
		"prijs": 300
	},
	"smg": {
		"auto": true,
		"damage": 5,
		"prijs": 800
	}
}

var player_ingame = {
	"wave": 0,
	"score": 0,
	"kills": 0
}

var player = {#set standard value of the players stats these will be overwritten if there is a game-data.json
	"config_version": 1,
	"speed": 10,
	"hp": 100,
	"money_multiplier": 1,
	
	"weapons": {
		"pistol": {
			"unlocked": true,#of je het wapen hebt
			"upgraded": 1 #hoe vaak het wapen is geupgrade
		},
		"smg": {
			"unlocked": false,
			"upgraded": 1 
		},
		"shotgun": {
			"unlocked": false,
			"upgraded": 1 
		}
	},
	
	"b_bucks": 0,
	"total_waves": 0,
	"total_score": 0,
	"total_kills": 0
}
#[["pistol", true, 1], ["rifle", false, 1], ["shotgun", false, 1]],

var settings = {
	"video": {
	"fullscreen": true,
	"resolution": [1920, 1080],
	},
	"mouse": {
	"mouse_sense": 50,
	},
	"keybinds": {
		"move_left": 65,
		"move_right": 68,
		"move_backward": 83,
		"move_forward": 87,
		"sprint": 4
	}
}

func switch_scene(scene):
	var error_code = get_tree().change_scene(scene)
	if error_code != OK:
		printerr("ERROR: ", error_code)

func del_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func random_num(from, to):
	var random_num = rand_range((from-1), to)
	random_num = (random_num)
	random_num += 1
	return random_num
#	var random = RandomNumberGenerator.new()
#	random.randomize()
#	return (random.randi_range(from, to)) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func save_data(data, file_path):
	print("filepath: ", file_path)
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	print("data saved")
	


func load_data(data, file_path):
	print("filepath: ", file_path)
	var file = File.new()
	file.open(file_path, File.READ)
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			printerr("Corrupted data!")
	else:
		file.close()
		printerr("No saved data!")
		printerr("Creating file...")
		save_data(data, file_path)
		printerr("Retrying to load data")
		load_data(data, file_path)#retrying to load data
	

func apply_settings():
	OS.window_fullscreen = settings["video"]["fullscreen"]#fullscreen ja of nee
	OS.set_window_size(Vector2(settings["video"]["resolution"][0],settings["video"]["resolution"][1]))#resolutie

#loopt over de dictionary keybinds in settings waarbij de key de key is van de dictionary als string
#dus niet de key van eventkey. in de key zit de scancode voor een knop zoals 86
	for key in settings["keybinds"]:
		var action_name = key#iets duidelijkere naam
		var action_key = settings["keybinds"][key]#haalt de scancode op
			
		var new_key = InputEventKey.new()#maakt een inputeventkey aan waarmee de game-engine werkt
		new_key.set_scancode(action_key)#maakt de toets die er aan is gelinkt de scancode nummer

		InputMap.action_erase_events(action_name) #delete je inputmap action zodat er een nieuwe kan komen
		InputMap.action_add_event(action_name, new_key)# maakt de niewe aan met dezelfde naam en niewe toets
