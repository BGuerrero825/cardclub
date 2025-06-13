class_name CardInterface extends Node2D 

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
	if body.pointer == null and body.tether == null:
		item.jump()
	card.flip()


func enter_hand(new_hand: Hand) -> ItemBody:
	body.velocity = vz
	body.tether = new_hand
	item.lift()
	if !card.up:
		card.flip()
	return body


func to_stack(stack_up: ):
	if stack_up != card.up: 
		card.flip()


func set_tether(new_tether: Area2D):
	body.tether = new_tether 
	body.move_to_front()


func set_hand_pos(new_hand, new_hand_pos):
	body.tether = new_hand 
	body.hand_pos = new_hand_pos
	body.move_to_front()


func is_flipped(up: bool):
	if card.up == up and card.flip_dir == 0:
		return true
	return false
