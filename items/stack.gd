extends Node2D

var cards: Array[String] = \
['ah', '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', 'th', 'jh', 'qh', 'kh',
 'ac', '2c', '3c', '4c', '5c', '6c', '7c', '8c', '9c', 'tc', 'jc', 'qc', 'kc',
 'ad', '2d', '3d', '4d', '5d', '6d', '7d', '8d', '9d', 'td', 'jd', 'qd', 'kd',
 'as', '2s', '3s', '4s', '5s', '6s', '7s', '8s', '9s', 'ts', 'js', 'qs', 'ks',
 'jo', 'jj']

var card_scene = preload("res://items/card.tscn")

@onready var item := get_parent()

func draw(actor: Node2D) -> Node2D:
	var card = card_scene.instantiate()
	card.get_node("Card").type = cards.pop_front()
	get_parent().get_parent().add_child(card)
	card.transform = self.get_global_transform()
	return card.handler.interact(actor)
