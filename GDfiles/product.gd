extends VBoxContainer

var product_name = "pistol"
var product_old = product_name

onready var test_shop = get_node("../../../..")
onready var preview = get_node("./ViewportContainer/Viewport/Spatial/Item")
onready var upgrade_progress = get_node("Bottom/VBoxContainer/Control/TextureProgress")
onready var up_btn = get_node("Bottom/VBoxContainer/UpBtn")

# Called when the node enters the scene tree for the first time.
func _ready():
	change_product()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	upgrade_progress.value = Globals.player["weapons"][product_name]["upgraded"]

func change_product():		
	var new = get_node("ViewportContainer/Viewport/Spatial/Item/"+ product_name)
	var old = get_node("ViewportContainer/Viewport/Spatial/Item/"+ product_old)
	old.visible = false
	new.visible = true
	new.translation = new.translation 
	product_old = product_name
	
	btn_status()


func _on_UpBtn_pressed():
	if up_btn.text == "Purchase" && Globals.WEAPONS[product_name]["prijs"] <= Globals.player["b_bucks"]:
		Globals.player["b_bucks"] -= Globals.WEAPONS[product_name]["prijs"]
		Globals.player["weapons"][product_name]["unlocked"] = true
		btn_status()
		Globals.save_data(Globals.player, Globals.PLAYER_PROGRES)
		
	elif up_btn.text == "Upgrade $100" && Globals.player["b_bucks"] >= 100:
		Globals.player["b_bucks"] -= 100
		Globals.player["weapons"][product_name]["upgraded"] += 1
		btn_status()
		Globals.save_data(Globals.player, Globals.PLAYER_PROGRES)
		
	test_shop.add_products()

func btn_status():
	if Globals.player["weapons"][product_name]["unlocked"]:
		if Globals.player["weapons"][product_name]["upgraded"] >= 10:
			up_btn.text = "Maxed"
		else:
			up_btn.text = "Upgrade $100"
	else:
		up_btn.text = "Purchase"
