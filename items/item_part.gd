class_name ItemPart extends Node2D 

const height_speed := 4
const height_min := -20

var height_dir := 0
var height_pos := 0
var jumping = false 

@onready var body := $".."
@onready var coll := $"../CollisionShape2D"
@onready var sprite := $"../Animation/Sprite2D"
@onready var shadow := $"../Animation/Shadow"

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if height_dir:
		animate_height()

# EXTERNAL #

func lift():
	height_dir = -1

func drop():
	height_dir = 1

func jump():
	body.move_to_front()
	height_dir = -1
	jumping = true
	

# INTERNAL #

func animate_height():
	height_pos += height_dir * height_speed

	if height_pos < height_min: # hit apex
		height_pos = height_min
		height_dir = 0
		if jumping:
			height_dir = 1

	elif height_pos > 0: # hit floor
		height_pos = 0
		height_dir = 0
		if jumping:
			jumping = false

	sprite.position.y = height_pos
	coll.position.y = height_pos
