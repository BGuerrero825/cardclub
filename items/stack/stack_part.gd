class_name StackPart extends Node2D

const ESCAPE_VELO = 150.
const SIZE_BASE := 54

var cards: Array[String] = \
['ah', '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', 'th', 'jh', 'qh', 'kh',
 'ac', '2c', '3c', '4c', '5c', '6c', '7c', '8c', '9c', 'tc', 'jc', 'qc', 'kc',
 'ad', '2d', '3d', '4d', '5d', '6d', '7d', '8d', '9d', 'td', 'jd', 'qd', 'kd',
 'as', '2s', '3s', '4s', '5s', '6s', '7s', '8s', '9s', 'ts', 'js', 'qs', 'ks',
 'jo', 'jj']

var card_scene = preload("res://items/card/card.tscn")
var up := false
var shuffling := false
var shuffle_step := 5
var shuffle_stagger := .4

@onready var body := $".."
@onready var sprite := $"../Animation/CardSprite"
@onready var area := $"../Area2D"
@onready var card_sprites := sprite.get_children()


func _process(_delta: float) -> void:
	suck_cards()

	if shuffling: animate_shuffle()


func draw_card(actor: Node2D) -> ItemBody:
	var drawn_card = spawn_card()

	if cards.size() == 1:
		var final_card = spawn_card()
		final_card.position.y += 12

	if cards.size() <= 0:
		body.queue_free()

	show_sprites()

	return drawn_card.iface.interact(actor)


func tether_card(card: ItemBody):
	card.iface.set_tether(area)
	card.iface.to_stack(up)
	card.connect("reached_target", stack_card)


func stack_card(card: ItemBody, _target_pos):
	if card.iface.is_flipped(up):
		cards.push_front(card.iface.card.type)
		card.reached_target.disconnect(stack_card)
		card.queue_free()
		show_sprites()
	elif card.iface.is_flipped(!up):
		card.iface.flip()


func spawn_card() -> ItemBody:
	var card = card_scene.instantiate()
	card.get_node("Card").type = cards.pop_front()
	get_parent().get_parent().add_child(card)
	card.transform = body.get_global_transform()
	return card


func show_sprites():
	var interval = SIZE_BASE / float(- 1)
	var drawn = max(SIZE_BASE - cards.size(), 0)
	@warning_ignore("integer_division")
	var to_hide: int = int(drawn / interval)
	print("to_hide: ", to_hide)

	for card_sprite in card_sprites: # reveal all cards
		sprite.visible = true

	for idx in range(to_hide): # re-hide cards based on amount of cards drawn
		card_sprites[(card_sprites.size() - idx) - 1].visible = false
	
	area.position = card_sprites[(card_sprites.size() - to_hide) - 1].position

func shuffle():
	cards.shuffle()
	shuffling = true

func animate_shuffle():
	for idx in range(card_sprites.size()):
		if abs(card_sprites[idx].rotation_degrees) >= 360:
			card_sprites[idx].rotation_degrees = 360
			continue
		var dir = 1 if idx % 2 == 0 else -1
		card_sprites[idx].rotation_degrees += dir * (shuffle_step + idx * shuffle_stagger)

	if abs(card_sprites[0].rotation_degrees) >= 360: # reset cards when slowest card hits 360
		shuffling = false
		for idx in range(card_sprites.size()):
			card_sprites[idx].rotation_degrees = 0
	print("rotation degs", card_sprites[0].rotation_degrees)

func suck_cards():
	if area.get_overlapping_bodies().size() < 1:
		return

	for overlap in area.get_overlapping_bodies():
		if overlap is ItemBody and "card" in overlap.iface \
		and overlap.pointer == null and overlap.tether == null:
			if overlap.velocity.length() < ESCAPE_VELO:
				tether_card(overlap)
				
