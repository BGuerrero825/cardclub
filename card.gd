extends CharacterBody2D 

@export var type := 'jo'

const vz = Vector2.ZERO 
var magnetism := 15.0
var rotation_magnetism := .2 
var angular_velocity := .0
var angular_velocity_ratio := .002
var friction := .15
var flip_step = .2

var holder: Node2D = null
var up := false
var flip_dir := 0
var height_dir := 0

@onready var up_frame := frame_from_type()
@onready var animation := $Animation
@onready var sprite := $Animation/Sprite2D 
@onready var shadow := $Animation/Shadow

func _physics_process(delta: float) -> void:
	if holder:
		magnetize_to_hand()
	else: 
		slide_on_table()
		rotate(angular_velocity * delta)

	if flip_dir:
		animate_flip()
	
	if height_dir:
		animate_height()
	
	move_and_slide()
		
func magnetize_to_hand():
	velocity = lerp(vz, holder.position - self.position, magnetism)
	rotation = lerp(rotation, 0., rotation_magnetism)

func slide_on_table():
	velocity = lerp(velocity, vz, friction)
	angular_velocity = lerp(angular_velocity, 0., friction)
	if velocity.length() < 1:
		velocity = vz

func animate_flip():
	if flip_dir == -1:
		animation.scale.x = move_toward(animation.scale.x, 0., flip_step)
		if animation.scale.x < flip_step:
			flip_frame()
			flip_dir = 1
	if flip_dir == 1:
		animation.scale.x = move_toward(animation.scale.x, 1., flip_step)
		if animation.scale.x > 1. - flip_step:
			animation.scale.x = 1 
			flip_dir = 0

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

func pickup(new_holder: Object):
	velocity = vz
	holder = new_holder
	move_to_front()
	height_dir = -1

func drop():
	holder = null
	angular_velocity = velocity.x * angular_velocity_ratio
	height_dir = 1

func flip():
	if flip_dir == 0:
		flip_dir = -1

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


# signals callbacks
func _on_rigid_body_2d_mouse_entered() -> void:
	pass # Replace with function body.


func _on_rigid_body_2d_mouse_exited() -> void:
	pass # Replace with function body.

