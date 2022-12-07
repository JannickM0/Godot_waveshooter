extends VBoxContainer

var action

var can_change_key = false
var action_string

var keybind_btn = preload("res://Assets/ui/settings/keyboard/keybind_btn.tscn")


onready var settings = get_node("../../../../../")
onready var popup = get_node("../../../../../Popup")
onready var popup_text = get_node("../../../../../Popup/Label")


enum keybind_buttons {
	sprint,
	move_left,
	move_right,
	move_backward,
	move_forward
}

func _ready():
	var all_keybind_buttons = keybind_buttons.keys()
	for value in keybind_buttons.values():
		var action = all_keybind_buttons[value]

		var new_btn = keybind_btn.instance()
		new_btn.text = action
		new_btn.connect("pressed", self, "_on_keybind_btn_pressed", [action])
		add_child(new_btn)

func _on_keybind_btn_pressed(keybind):
	action = keybind
	can_change_key = true
	popup.visible = true
	popup_text.text = "input a key"
	
func _input(event):
	if can_change_key:
		if event is InputEventKey:#checks if input is a keyboard key not mouse movement or mouse buttons
			change_keybind(event)


func change_keybind(key):
	settings.settings["keybinds"][action] = key.scancode#zet de toets als scancode erin want je kan geen classes zoals InputEventKey opslaan in json
	can_change_key = false
	popup.visible = false



