class_name Item extends CharacterBody2D 

const vz = Vector2.ZERO 
var magnetism := 15.0
var friction := .15

var holder: Node2D = null

@onready var subitem := $SubItem 

func _ready() -> void:
	assert("item" in subitem)

func _physics_process(_delta: float) -> void:
	if holder:
		magnetize_to_hand()
	else: 
		slide_on_table()

	move_and_slide()
		
func magnetize_to_hand():
	velocity = lerp(vz, holder.position - self.position, magnetism)

func slide_on_table():
	velocity = lerp(velocity, vz, friction)
	if velocity.length() < 1:
		velocity = vz

func pickup(new_holder: Object):
	if subitem.has_method("pickup"):
		subitem.pickup()
	velocity = vz
	holder = new_holder
	move_to_front()

func drop():
	if subitem.has_method("drop"):
		subitem.drop()
	holder = null

func flip():
	if subitem.has_method("flip"):
		subitem.flip()
