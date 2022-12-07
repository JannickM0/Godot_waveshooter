extends VBoxContainer

onready var settings = get_node("../../../../../")

onready var mouse_sense_slider = get_node("HBoxContainer/HSlider")

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_sense_slider.value = Globals.settings["mouse"]['mouse_sense']


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	settings.settings["mouse"]["mouse_sense"] = value
