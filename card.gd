extends CharacterBody2D 

@export var type := 'jo'

var magnetism := 15.0
var angular_velocity := 0.
var angular_velocity_ratio := .001
var friction := .15

var holder: Node2D = null
var up := false
var flipping := 0
var flip_speed = .15

@onready var up_frame := frame_from_type()
@onready var animation := $Animation
@onready var sprite := $Animation/Sprite2D 

func _physics_process(delta: float) -> void:
	if holder:
		velocity = lerp(Vector2.ZERO, holder.position - self.position, magnetism)
		rotation = lerp(rotation, 0., .5)
	else: 
		velocity = lerp(velocity, Vector2.ZERO, friction)
		if velocity.length() < 1:
			velocity = Vector2.ZERO
		if not velocity.is_zero_approx():
			print("velocity: ", velocity) 
			rotation += angular_velocity * delta
			angular_velocity = lerp(angular_velocity, 0., friction)
	if flipping == -1:
		animation.scale.x = move_toward(animation.scale.x, 0., flip_speed)
		print("scale: ", animation.scale.x)
		if animation.scale.x < flip_speed:
			print("hit zero")
			flip_frame()
			flipping = 1
	if flipping == 1:
		animation.scale.x = move_toward(animation.scale.x, 1., flip_speed)
		if animation.scale.x > 1. - flip_speed:
			animation.scale.x = 1 
			flipping = 0
		

	self.move_and_slide()
		
func pickup(new_holder: Object):
	velocity = Vector2.ZERO
	holder = new_holder
	move_to_front()

func drop():
	holder = null
	angular_velocity = velocity.length() * angular_velocity_ratio;
	if velocity.x < 0:
		angular_velocity *= -1

func flip():
	if flipping == 0:
		flipping = -1

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

