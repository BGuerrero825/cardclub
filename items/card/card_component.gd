class_name CardComponent extends Node2D 

@export var type := 'jo'

var rotation_magnetism := .2 
var angular_velocity := .0
var angular_velocity_ratio := .002
var flip_step = .2

var up := false
var flip_dir := 0

@onready var body := $".."
@onready var anim := $"../Animation"
@onready var sprite := $"../Animation/CardSprite"
@onready var shadow := $"../Animation/Shadow"
@onready var stacker := $"../Stacker"
@onready var up_frame := frame_from_type()


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if body.pointer or body.tether:
		rotate_to_hand()
	else:
		rotate_on_table(delta)

	if flip_dir:
		animate_flip()


# EXTERNAL #

func try_stacking() -> ItemBody:
	var overlaps = stacker.get_overlapping_bodies()
	if overlaps.size() <= 1:
		return null

	overlaps.erase(body)
	if overlaps[0] is ItemBody and overlaps[0].cardcom \
	and overlaps[0].pointer == null and overlaps[0].tether == null:
		var stack = Global.spawner.spawn_stack()
		stack.position = body.position
		stack.stackcom.cards.clear()
		stack.stackcom.cards.append(self.type)
		stack.stackcom.show_sprites()
		body.queue_free()
		return stack

	return null

func drop():
	angular_velocity = body.velocity.x * angular_velocity_ratio
	
func flip():
	if flip_dir == 0:
		flip_dir = -1


# INTERNAL #
	
func rotate_to_hand():
	anim.rotation = lerp(anim.rotation, 0., rotation_magnetism)

func rotate_on_table(delta):
	angular_velocity = lerp(angular_velocity, 0., body.friction)
	anim.rotate(angular_velocity * delta)

func animate_flip():
	if flip_dir == -1:
		anim.scale.x = move_toward(anim.scale.x, 0., flip_step)
		if anim.scale.x < flip_step:
			flip_frame()
			flip_dir = 1
	if flip_dir == 1:
		anim.scale.x = move_toward(anim.scale.x, 1., flip_step)
		if anim.scale.x > 1. - flip_step:
			anim.scale.x = 1 
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
