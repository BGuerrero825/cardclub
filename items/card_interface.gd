class_name CardHandler extends Node2D 

const vz = Vector2.ZERO 

@onready var body := $".."
@onready var item := $"../Item"
@onready var card := $"../Card"
@onready var items := [item, card]

func _ready() -> void:
	pass

func interact(pointer: Pointer) -> ItemBody:
	item.lift()
	body.velocity = vz
	body.set_pointer(pointer)
	body.move_to_front()
	return body

func stop_interact() -> ItemBody:
	item.drop()
	card.drop()
	body.set_pointer(null)
	return null

func action():
	flip()

func flip():
	if body.pointer == null and body.hand == null:
		item.jump()
	card.flip()

func enter_hand(new_hand: Hand) -> ItemBody:
	body.velocity = vz
	body.hand = new_hand
	item.lift()
	if !card.up:
		card.flip()
	return body

func adjust_in_hand(new_pos: Vector2):
	body.hand_pos = new_pos
	body.move_to_front()
	item.lift()
