extends Control

var SETTINGS = Globals.SETTINGS
var settings = Globals.settings

onready var video = get_node("VBoxContainer/VScrollBar/HBoxContainer/VBoxContainer/Video")
onready var mouse = get_node("VBoxContainer/VScrollBar/HBoxContainer/VBoxContainer/Mouse")
onready var keyboard = get_node("VBoxContainer/VScrollBar/HBoxContainer/VBoxContainer/Keyboard")

onready var tabs = [video, mouse, keyboard]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_VideoBtn_pressed():
	switch_tab(video)

func _on_Mouse_pressed():
	switch_tab(mouse)

func _on_Keyboard_pressed():
	switch_tab(keyboard)

func switch_tab(tab):
	for i in range(0, tabs.size()):
		var node = tabs[i]
		node.visible = false
		
	tab.visible = true 

func save_settings():
	Globals.save_data(settings, SETTINGS)

func _on_Save_pressed():
	save_settings()
	Globals.apply_settings()


func _on_Back_pressed():
	Globals.switch_scene("res://Assets/ui/titelscreen/Titlescreen.tscn")

