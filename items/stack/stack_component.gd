class_name StackComponent extends Node2D

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
@onready var tether := $"../Tether"
@onready var card_sprites := sprite.get_children()


func _process(_delta: float) -> void:
	suck_cards()

	if shuffling: animate_shuffle()

# EXTERNAL #

func lift():
	tether.scale *= 1.2

func drop():
	tether.scale /= 1.2

func draw_card(actor: Node2D) -> ItemBody:
	var drawn_card = spawn_card()

	if cards.size() == 1:
		spawn_card()

	if cards.size() <= 0:
		body.queue_free()

	show_sprites()

	return drawn_card.interact(actor)


func tether_card(card: ItemBody):
	card.set_tether(tether)
	card.to_stack(up)
	card.connect("reached_target", stack_card)


func stack_card(card: ItemBody, _target_pos):
	if card.is_flipped(up):
		cards.push_front(card.cardcom.type)
		card.reached_target.disconnect(stack_card)
		card.queue_free()
	elif card.is_flipped(!up):
		card.flip()
	show_sprites()


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


# INTERNAL #

func suck_cards():
	var overlaps: Array = tether.get_overlapping_bodies()
	if overlaps.size() <= 1:
		return
	overlaps.erase(body)

	for overlap in overlaps:
		if overlap is ItemBody and overlap.cardcom \
		and overlap.pointer == null and overlap.tether == null:
			if overlap.velocity.length() < ESCAPE_VELO:
				tether_card(overlap)


func spawn_card() -> ItemBody:
	var card = card_scene.instantiate()
	card.cardcom.type = cards.pop_front()
	get_parent().get_parent().add_child(card)
	card.transform = body.get_global_transform()
	return card


func show_sprites():
	@warning_ignore("integer_division")
	var interval = SIZE_BASE / (card_sprites.size() - 1)
	var drawn = max(SIZE_BASE - cards.size(), 0)
	body.debug.display("drawn", drawn)
	var to_hide: int = int(drawn / interval)
	body.debug.display("to_hide", to_hide)

	for idx in range(card_sprites.size()): # hide or reveal cards based on drawn #
		if idx >= card_sprites.size() - to_hide:
			card_sprites[idx].visible = false
		else:
			card_sprites[idx].visible = true

	tether.global_position = card_sprites[(card_sprites.size() - to_hide) - 1].global_position

