class_name CardHandler extends Node2D 

const vz = Vector2.ZERO 

@onready var body := $".."
@onready var item := $"../Item"
@onready var card := $"../Card"
@onready var items := [item, card]

func _ready() -> void:
	pass

func interact(new_holder: Node2D) -> ItemBody:
	item.lift()
	body.velocity = vz
	body.pointer = new_holder
	body.move_to_front()
	return body

func stop_interact() -> ItemBody:
	item.drop()
	card.drop()
	body.pointer = null
	return null

func action():
	flip()

func flip():
	if body.pointer == null and body.hand == null:
		item.jump()
	card.flip()

func enter_hand(new_hand: Hand) -> ItemBody:
	# TODO: trigger me on body entered if no pointer
	item.lift()
	body.velocity = vz
	body.hand = new_hand
	return body

func leave_hand():
	body.hand = null

func adjust_in_hand(new_pos: Vector2):
	body.hand_pos = new_pos
	body.move_to_front()
	item.lift()
