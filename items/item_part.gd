class_name ItemPart extends Node2D 

var height_dir := 0
var height_pos := 0
var jumping = false 
var jump_hang = 0

@export var height_apex = -20
@export var height_speed = 4
@export var jump_timer = 0

@onready var body := $".."
@onready var coll := $"../CollisionShape2D"
@onready var sprite := $"../Animation/CardSprite"
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
	jump_hang = jump_timer
	

# INTERNAL #

func animate_height():
	if height_dir == 1 and jump_hang > 0:
		jump_hang -= 1
		return

	height_pos += height_dir * height_speed

	if height_pos < height_apex: # hit apex
		height_pos = height_apex
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
