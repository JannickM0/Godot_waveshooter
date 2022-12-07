extends Button

var label

onready var shop = get_node("../../../../../..")

func _ready():
	label = get_node("Label")



func _on_GunName_pressed():
	print(label.text)
	shop.change_weapon(label.text)
