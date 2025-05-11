extends CharacterBody2D 

var holder: Object = null
var magnetism := 8.0
var friction := .15

func _physics_process(_delta: float) -> void:
	if holder:
		velocity = lerp(Vector2.ZERO, holder.position - self.position, magnetism)
	else: 
		velocity = lerp(velocity, Vector2.ZERO, friction)

	self.move_and_slide()
		
func pickup(new_holder: Object):
	velocity = Vector2.ZERO
	holder = new_holder

func drop():
	holder = null

# signals callbacks
func _on_rigid_body_2d_mouse_entered() -> void:
	pass # Replace with function body.


func _on_rigid_body_2d_mouse_exited() -> void:
	pass # Replace with function body.

