class_name CardHandler extends Node2D 

const vz = Vector2.ZERO 

@onready var body := $".."
@onready var item := $"../Item"
@onready var card := $"../Card"
@onready var items := [item, card]

func _ready() -> void:
	pass

func interact(new_holder: Node2D) -> ItemBody:
	item.pickup()
	body.velocity = vz
	body.holder = new_holder
	body.move_to_front()
	return body

func stop_interact():
	item.drop()
	card.drop()
	body.holder = null

func action():
	flip()

func flip():
	if body.holder == null:
		item.jump()
	card.flip()
