class_name ItemBody extends CharacterBody2D 

const vz = Vector2.ZERO 
const TABLE_Z = 0
const HAND_Z = 10
const POINTER_Z = 20

@export var magnetism := 15.0
@export var friction := .15
@export var snap_distance := 1.5 

var pointer: Pointer = null
var tether: Node2D = null
var hand_pos = vz

signal grabbed_by(item, pointer)
signal reached_target(item, target_pos)

@onready var iface := $Interface

func _ready() -> void:
	# add some asserts
	pass

func _physics_process(_delta: float) -> void:
	var target_pos = null
	if pointer:
		z_index = POINTER_Z
		target_pos = pointer.global_position
	elif tether:
		z_index = HAND_Z
		if hand_pos:
			target_pos = hand_pos
		else:
			target_pos = tether.global_position
	else: 
		z_index = TABLE_Z
	
	move_item(target_pos)


func move_item(target_pos):
	if target_pos:
		velocity = lerp(vz, target_pos - self.global_position, magnetism)
		move_and_slide()
		if (self.global_position - target_pos).length() < snap_distance:
			self.global_position = target_pos
			reached_target.emit(self, target_pos)
	else:
		velocity = lerp(velocity, vz, friction)
		if velocity.length() < 1:
			velocity = vz
		move_and_slide()


func set_pointer(new_pointer: Pointer):
	pointer = new_pointer
	if pointer != null:
		grabbed_by.emit(self, pointer)
