class_name Hand extends Area2D

const  MAX_OFFSET_CARDS = 10.

var cards: Array[ItemBody] = [] 
var adjusted_to_size := 0
var span = 0
var start_at = 0
var offset = 0


@onready var hand_width = $CollisionShape2D.shape.height

func _process(_delta: float) -> void:
	suck_cards()
	if adjusted_to_size != cards.size():
		adjust_cards()


func add_item(item: ItemBody):
	var new_item = item.handler.enter_hand(self)
	if new_item == null:
		return
	var rel_pos = new_item.global_position - self.global_position
	var placed = false
	for idx in range(cards.size()):
		if rel_pos.x < start_at + (offset * idx):
			cards.insert(idx, new_item)
			placed = true
			break
	if not placed:
		cards.push_back(new_item)
	new_item.grabbed_by.connect(remove_item)


func remove_item(item: ItemBody, _grabber: Pointer):
	# item.leave_hand() ?
	item.hand = null
	item.grabbed_by.disconnect(remove_item)
	cards.erase(item)


func suck_cards():
	if self.get_overlapping_bodies().size() <= cards.size():
		return
	for item in self.get_overlapping_bodies():
		if item is ItemBody and item.pointer == null and item.hand == null:
			add_item(item)


func adjust_cards():
	calc_card_offsets()
	# apply offsets based on index
	for idx in range(cards.size()):
		var xpos = self.global_position.x + start_at + (offset * idx)
		cards[idx].handler.adjust_in_hand(Vector2(xpos, self.global_position.y))

	adjusted_to_size = cards.size()


func calc_card_offsets():
	if cards.size() <= 1:
		span = 0
		start_at = 0
		offset = 0
	else:
		span = hand_width * min(1, cards.size() / MAX_OFFSET_CARDS)
		start_at = (span / 2.) * -1.
		offset = span / (cards.size() - 1)
