extends Control

onready var label = get_node("PriceLabel")
onready var currency_icon = get_node("CurrencyIcon")

func remove_currency():
	label.set_position(Vector2(20, 0))
	currency_icon.queue_free()
