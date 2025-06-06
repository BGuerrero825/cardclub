class_name ItemBody extends CharacterBody2D 

const vz = Vector2.ZERO 
const TABLE_Z = 0
const HAND_Z = 1
const POINTER_Z = 2

@export var magnetism := 15.0
@export var friction := .15

var pointer: Pointer = null
var hand: Hand = null
var hand_pos = Vector2.ZERO

signal grabbed_by(grabee, grabber)

@onready var handler := $Handler

func _ready() -> void:
	# add some asserts
	pass

func _physics_process(_delta: float) -> void:
	if pointer:
		z_index = POINTER_Z 
		magnetize_velocity(pointer.position)
	elif hand:
		z_index = HAND_Z
		magnetize_velocity(hand_pos)
	else: 
		z_index = TABLE_Z 
		slide_velocity()

	move_and_slide()

func magnetize_velocity(target: Vector2):
	if target == Vector2.ZERO:
		print("ZEROOOOOO target")
	velocity = lerp(vz, target - self.position, magnetism)

func slide_velocity():
	velocity = lerp(velocity, vz, friction)
	if velocity.length() < 1:
		velocity = vz

func set_pointer(new_pointer: Pointer):
	pointer = new_pointer
	if pointer != null:
		grabbed_by.emit(self, pointer)
