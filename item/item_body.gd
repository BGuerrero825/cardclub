class_name ItemBody extends CharacterBody2D 

const vz = Vector2.ZERO 

@export var magnetism := 15.0
@export var friction := .15

var holder: Node2D = null

@onready var handler := $Handler

func _ready() -> void:
	# add some asserts
	pass

func _physics_process(_delta: float) -> void:
	if holder:
		magnetize_to_hand()
	else: 
		slide_on_table()

	move_and_slide()

func pickup(new_holder):
	velocity = vz
	holder = new_holder
	move_to_front()
		
func magnetize_to_hand():
	velocity = lerp(vz, holder.position - self.position, magnetism)

func slide_on_table():
	velocity = lerp(velocity, vz, friction)
	if velocity.length() < 1:
		velocity = vz
