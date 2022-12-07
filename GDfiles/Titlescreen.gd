extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_PlayBtn_pressed():
	Globals.switch_scene("res://Assets/levels/Level3.tscn")


func _on_ShopBtn_pressed():
	Globals.switch_scene("res://Assets/ui/shop/shop.tscn")

func _on_StatsBtn_pressed():
	Globals.switch_scene("res://Assets/ui/stats/Stats.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()

func _on_Settings_pressed():
	Globals.switch_scene("res://Assets/ui/settings/settings.tscn")
