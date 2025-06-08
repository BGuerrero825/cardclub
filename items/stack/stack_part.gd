class_name StackPart extends Node2D


var cards: Array[String] = \
['ah', '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', 'th', 'jh', 'qh', 'kh',
 'ac', '2c', '3c', '4c', '5c', '6c', '7c', '8c', '9c', 'tc', 'jc', 'qc', 'kc',
 'ad', '2d', '3d', '4d', '5d', '6d', '7d', '8d', '9d', 'td', 'jd', 'qd', 'kd',
 'as', '2s', '3s', '4s', '5s', '6s', '7s', '8s', '9s', 'ts', 'js', 'qs', 'ks',
 'jo', 'jj']

var card_scene = preload("res://items/card/card.tscn")

@onready var body := $".."
@onready var sprite := $"../Animation/CardSprite"
@onready var area := $"../Area2D"
@onready var init_size := cards.size()

func _process(_delta: float) -> void:
	suck_cards()

func draw(actor: Node2D) -> ItemBody:
	var drawn_card = spawn_card()

	if cards.size() == 1:
		var final_card = spawn_card()
		final_card.position.y += 12

	if cards.size() <= 0:
		body.queue_free()

	show_sprites()

	return drawn_card.iface.interact(actor)

func stack_card(item: ItemBody):
	print("stacking card")
	cards.push_front(item.iface.card.type)
	item.iface.stack_recall(area)

	show_sprites()

func spawn_card() -> ItemBody:
	var card = card_scene.instantiate()
	card.get_node("Card").type = cards.pop_front()
	get_parent().get_parent().add_child(card)
	card.transform = body.get_global_transform()
	return card


func show_sprites():
	var card_sprites = sprite.get_child_count()
	print("card_sprites: ", card_sprites)
	var interval = init_size / float(card_sprites - 1)
	var drawn = init_size - cards.size()
	@warning_ignore("integer_division")
	var to_hide: int = int(drawn / interval)
	print("to_hide: ", to_hide)

	for idx in range(1, card_sprites + 1):
		sprite.get_node("Sprite"+str(idx)).visible = true

	for idx in range(1, to_hide + 1):
		sprite.get_node("Sprite"+str(idx)).visible = false


func suck_cards():
	if area.get_overlapping_bodies().size() < 1:
		return
	for overlap in area.get_overlapping_bodies():
		if overlap != body and overlap.pointer == null:
			if overlap.zone == null:
				stack_card(overlap)
			elif overlap.zone == area and (overlap.global_position - area.global_position).length() < .1:
				overlap.queue_free()


