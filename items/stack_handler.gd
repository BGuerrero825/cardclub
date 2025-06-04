class_name StackHandler extends Node2D 

const vz = Vector2.ZERO 

@onready var body := $".."
@onready var item := $"../Item"
@onready var stack := $"../Stack"
@onready var items := [item, stack]

func _ready() -> void:
	pass

func interact(actor: Node2D):
	return stack.draw(actor)

func long_interact(actor: Node2D) -> Node2D:
	item.lift()
	body.pointer = actor
	return body

func stop_interact() -> ItemBody:
	item.drop()
	body.pointer = null
	return null

func action():
	# shuffle?
	pass

func flip():
	pass

func enter_hand(_dummy):
	return
