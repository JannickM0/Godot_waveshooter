extends Control

onready var prices = $"VBoxContainer/Shop/HBoxContainer/HBoxContainer/Prices"
onready var select_product = $"VBoxContainer/Shop/HBoxContainer/HBoxContainer/SelecteerProduct"
onready var money_amount = get_node("VBoxContainer/Top/MoneyAmount/Label")
onready var product_preview = get_node("VBoxContainer/Shop/HBoxContainer/ProductPreview")

var price_and_product_margin = preload("res://Assets/ui/shop/price_and_product_margin.tscn")
var price_label = preload("res://Assets/ui/shop/pricelabel.tscn")
var gun_name = preload("res://Assets/ui/shop/product_btn.tscn")

func _ready():
	add_products()

func add_products():
	Globals.del_children(prices)
	Globals.del_children(select_product)
	
	for i in Globals.WEAPONS.keys():
		#zorgt dat je de prijs van het wapen ziet of dat je het al hebt
		var p = price_label.instance()
		prices.add_child(p)
		
		if Globals.player["weapons"][i]["unlocked"]:
			p.label.text = "owned"
			p.remove_currency()
		else:
			p.label.text = str(Globals.WEAPONS[i]["prijs"])
			
		var m1 = price_and_product_margin.instance()
		prices.add_child(m1)

		#zorgt voort de wapennaam met knop
		var g = gun_name.instance()
		select_product.add_child(g)
		g.label.text = i;
		var m2 = price_and_product_margin.instance()
		select_product.add_child(m2)


func _process(_delta):
	money_amount.text = str(Globals.player.b_bucks)#update 
	
	#zorgt ervoor dat je 3d wapen kan zien

func change_weapon(weapon):
	product_preview.product_name = weapon
	product_preview.change_product()


func _on_Back_pressed():
	Globals.switch_scene("res://Assets/ui/titelscreen/Titlescreen.tscn")
