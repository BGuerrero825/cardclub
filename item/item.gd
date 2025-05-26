class_name Item extends Node2D 

var height_dir := 0
var jumping = false 

@onready var body := $".."
@onready var sprite := $"../Animation/Sprite2D"
@onready var shadow := $"../Animation/Shadow"

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if height_dir:
		animate_height()

# EXTERNAL #

func pickup():
	height_dir = -1

func drop():
	height_dir = 1

func jump():
	body.move_to_front()
	height_dir = -1
	jumping = true
	

# INTERNAL #

func animate_height():
	if height_dir == -1:
		sprite.position.y -= 4.
		if sprite.position.y < -20:
			sprite.position.y = -20
			height_dir = 0
			if jumping:
				height_dir = 1

	if height_dir == 1:
		sprite.position.y += 4.
		if sprite.position.y > 0:
			sprite.position.y = 0
			height_dir = 0
			if jumping:
				jumping = false
