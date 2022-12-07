extends VBoxContainer

onready var settings = get_node("../../../../../")

onready var resolution = get_node("Resolution")
onready var fullscreen = get_node("Fullscreen/CheckBox")
# Called when the node enters the scene tree for the first time.
func _ready():
	fullscreen.pressed = Globals.settings["video"]["fullscreen"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Resolution_item_selected(index):
	var res = resolution.get_item_text(index)
	var res_lenght = res.length()
	res = res.substr(5,res_lenght)# haalt de aspect ratio eraf en er blijft alleen width x height
	res = res.split("×")# !!!!! deze × is niet deze x dus deze moet je copy paste

	settings.settings["video"]["resolution"] = [int(res[0]), int(res[1])]


func _on_Fullscreen_pressed():
	settings.settings["video"]["fullscreen"] = fullscreen.pressed
