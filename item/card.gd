class_name Card extends Node2D 

@export var type := 'jo'

var rotation_magnetism := .2 
var angular_velocity := .0
var angular_velocity_ratio := .002
var flip_step = .2

var up := false
var flip_dir := 0
var height_dir := 0

@onready var item := self.get_parent()
@onready var up_frame := frame_from_type()
@onready var sprite := $Sprite2D 
@onready var shadow := $Shadow


func _ready() -> void:
	assert(item is Item)

func _physics_process(delta: float) -> void:
	if item.holder:
		rotate_to_hand()
	else:
		rotate_on_table(delta)

	if flip_dir:
		animate_flip()
	if height_dir:
		animate_height()


# EXTERNAL #

func pickup():
	height_dir = -1

func drop():
	height_dir = 1
	angular_velocity = item.velocity.x * angular_velocity_ratio
	
func flip():
	if flip_dir == 0:
		flip_dir = -1



# INTERNAL #
	
func rotate_to_hand():
	rotation = lerp(rotation, 0., rotation_magnetism)

func rotate_on_table(delta):
	angular_velocity = lerp(angular_velocity, 0., item.friction)
	rotate(angular_velocity * delta)

func animate_height():
	if height_dir == -1:
		sprite.position.y -= 4.
		if sprite.position.y < -20:
			sprite.position.y = -20
			height_dir = 0
	if height_dir == 1:
		sprite.position.y += 4.
		if sprite.position.y > 0:
			sprite.position.y = 0
			height_dir = 0

func animate_flip():
	if flip_dir == -1:
		scale.x = move_toward(scale.x, 0., flip_step)
		if scale.x < flip_step:
			flip_frame()
			flip_dir = 1
	if flip_dir == 1:
		scale.x = move_toward(scale.x, 1., flip_step)
		if scale.x > 1. - flip_step:
			scale.x = 1 
			flip_dir = 0

func flip_frame():
	if up:
		sprite.frame = 54 # card back
		up = false 
	else:
		sprite.frame = up_frame
		up = true

func frame_from_type() -> int:
	var sprite_frame = 0
	if type == 'jo': return 52
	if type == 'jj': return 53
	match type[1]:
		'h':
			sprite_frame += 0
		'c':
			sprite_frame += 13
		'd':
			sprite_frame += 26
		's':
			sprite_frame += 39
		'_':
			return 52 # joker
	match type[0]:
		'2','3','4','5','6','7','8','9':
			sprite_frame += int(type[0]) - 2
		't':
			sprite_frame += 8
		'j':
			sprite_frame += 9
		'q':
			sprite_frame += 10
		'k':
			sprite_frame += 11
		'a':
			sprite_frame += 12
		'_':
			return 52 # joker

	return sprite_frame

