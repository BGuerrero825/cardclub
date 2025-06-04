class_name Hand extends Area2D

var cards: Array[ItemBody] = [] 
const  MAX_OFFSET_CARDS = 10.

@onready var hand_width = $CollisionShape2D.shape.height

func _process(_delta: float) -> void:
	adjust_cards()

func take_item(item: ItemBody):
	var new_item = item.handler.enter_hand(self)
	if new_item:
		cards.push_back(new_item)
		adjust_cards()

	#item.handler.calc_new_position(0)

func adjust_cards():
	var span = 0
	var start_at = 0
	var offset = 0
	if cards.size() > 1:
		span = hand_width * min(1, cards.size() / MAX_OFFSET_CARDS)
		start_at = (span / 2.) * -1.
		offset = span / (cards.size() - 1)

	var pop_after = []
	for idx in range(cards.size()):
		var xpos = self.global_position.x + start_at + (offset * idx)
		cards[idx].handler.adjust_in_hand(Vector2(xpos, self.global_position.y))
		if cards[idx].pointer:
			pop_after.append(idx)

	for pop_idx in pop_after:
		cards[pop_idx].handler.leave_hand()
		cards.pop_at(pop_idx)
		

